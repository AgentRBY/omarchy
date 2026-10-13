echo "Have the N1x firmware reserve 4 GiB for the GPU instead of reclaiming its 62.5 GiB in the kernel"

# See omarchy-apply-n1x-gpu-memory. The firmware's own setting replaces the
# efi_reclaim_reserved= kernel option the earlier migrations added, which
# linux-omarchy-n1x is dropping.
dropin="${OMARCHY_N1X_GPU_MEMORY_CONF:-/etc/limine-entry-tool.d/omarchy-n1x-gpu-memory.conf}"

omarchy-hw-aarch64-n1x || exit 0

sudo omarchy-apply-n1x-gpu-memory

if [[ -f $dropin ]]; then
  sudo rm "$dropin"
  sudo limine-mkinitcpio
fi
