#!/bin/bash
set -euo pipefail

SCRIPT_NAME="$(basename "$0")"

usage() {
    cat <<EOF
Usage:
  $SCRIPT_NAME [OPTIONS] <device> <label>

Formats a USB device as exFAT with an MBR (msdos) partition table.

Arguments:
  device         e.g. /dev/sdb
  label          exFAT volume label (maximum 11 characters)

Options:
  -y, --yes      skip interactive confirmation
  -f, --force    allow devices that are not marked as removable
  -h, --help     show this help message

Example:
  $SCRIPT_NAME /dev/sdb PENDRIVE

WARNING:
  ALL DATA on the specified device will be permanently erased.
EOF
}

YES=0
FORCE=0

while [[ $# -gt 0 ]]; do
    case "$1" in
        -y|--yes)
            YES=1
            shift
            ;;
        -f|--force)
            FORCE=1
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        --)
            shift
            break
            ;;
        -*)
            echo "Error: unknown option: $1" >&2
            echo >&2
            usage >&2
            exit 2
            ;;
        *)
            break
            ;;
    esac
done

if [[ $# -ne 2 ]]; then
    echo "Error: device and label are required." >&2
    echo >&2
    usage >&2
    exit 2
fi

PENDRIVE="$1"
PENDRIVE_LABEL="$2"

# ------------------------------------------------------------
# Check required tools
# ------------------------------------------------------------

for cmd in lsblk wipefs parted mkfs.exfat findmnt; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "Error: required command not found: $cmd" >&2
        exit 1
    fi
done

# ------------------------------------------------------------
# Validate device
# ------------------------------------------------------------

if [[ ! -b "$PENDRIVE" ]]; then
    echo "Error: '$PENDRIVE' is not a block device." >&2
    exit 1
fi

# Never allow modifications to NVMe devices
if [[ "$PENDRIVE" == *nvme* ]]; then
    echo "ERROR: NVMe devices are protected." >&2
    echo "Formatting or modifying NVMe devices is not allowed." >&2
    echo "Specified device: $PENDRIVE" >&2
    exit 1
fi

TYPE="$(lsblk -dnro TYPE "$PENDRIVE")"

if [[ "$TYPE" != "disk" ]]; then
    echo "Error: '$PENDRIVE' is not a whole disk." >&2
    echo "Please specify a disk device, for example /dev/sdb." >&2
    exit 1
fi

# ------------------------------------------------------------
# Prevent formatting the system disk
# ------------------------------------------------------------

ROOT_SOURCE="$(findmnt -nro SOURCE / || true)"

if [[ -n "$ROOT_SOURCE" ]]; then
    ROOT_DISK="$(lsblk -no PKNAME "$ROOT_SOURCE" 2>/dev/null || true)"

    if [[ -n "$ROOT_DISK" && "/dev/$ROOT_DISK" == "$PENDRIVE" ]]; then
        echo "ERROR: '$PENDRIVE' contains the active root filesystem (/)." >&2
        echo "Formatting has been blocked." >&2
        exit 1
    fi
fi

# ------------------------------------------------------------
# Validate exFAT label
# ------------------------------------------------------------

if [[ -z "$PENDRIVE_LABEL" ]]; then
    echo "Error: volume label cannot be empty." >&2
    exit 1
fi

if [[ ${#PENDRIVE_LABEL} -gt 11 ]]; then
    echo "Error: exFAT volume label must not exceed 11 characters." >&2
    exit 1
fi

# ------------------------------------------------------------
# Determine partition name
# ------------------------------------------------------------

case "$PENDRIVE" in
    /dev/mmcblk[0-9]*)
        PARTITION="${PENDRIVE}p1"
        ;;
    *)
        PARTITION="${PENDRIVE}1"
        ;;
esac

# ------------------------------------------------------------
# Show device information and ask for confirmation
# ------------------------------------------------------------

echo
echo "WARNING: ALL DATA ON THIS DEVICE WILL BE ERASED!"
echo
echo "Device:"
lsblk -d -o NAME,SIZE,MODEL,RM "$PENDRIVE"
echo
echo "Volume label: $PENDRIVE_LABEL"
echo "Filesystem: exFAT"
echo "Partition table: MBR (msdos)"
echo

if [[ "$YES" != "1" ]]; then
    read -r -p "Type 'FORMAT' to continue: " CONFIRM

    if [[ "$CONFIRM" != "FORMAT" ]]; then
        echo "Operation cancelled."
        exit 0
    fi
fi

# ------------------------------------------------------------
# Unmount existing partitions
# ------------------------------------------------------------

mapfile -t PARTITIONS < <(
    lsblk -lnpo NAME,TYPE "$PENDRIVE" |
    awk '$2 == "part" { print $1 }'
)

for partition in "${PARTITIONS[@]}"; do
    if findmnt -rn "$partition" >/dev/null 2>&1; then
        echo "Unmounting: $partition"
        sudo umount "$partition"
    fi
done

# ------------------------------------------------------------
# Format device
# ------------------------------------------------------------

echo
echo "Removing existing filesystem signatures..."
sudo wipefs -a "$PENDRIVE"

echo "Creating MBR partition table..."
sudo parted -s "$PENDRIVE" mklabel msdos

echo "Creating exFAT partition..."
sudo parted "${PENDRIVE}" --script mkpart primary exfat 0% 100%

echo "Refreshing partition information..."
sudo partprobe "$PENDRIVE" 2>/dev/null || true
sudo udevadm settle 2>/dev/null || true

# ------------------------------------------------------------
# Verify created partition
# ------------------------------------------------------------

if [[ ! -b "$PARTITION" ]]; then
    echo "Error: created partition was not found: $PARTITION" >&2
    exit 1
fi

echo "Formatting $PARTITION as exFAT..."
sudo mkfs.exfat -n "$PENDRIVE_LABEL" "$PARTITION"

echo
echo "Formatting completed successfully."
echo
lsblk -o NAME,SIZE,FSTYPE,LABEL,MOUNTPOINT "$PENDRIVE"
