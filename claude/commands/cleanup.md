System cleanup utility.

Show current disk usage and cleanup options:

```bash
echo "=== Disk Usage Analysis ==="
echo "Yay cache: $(du -sh ~/.cache/yay 2>/dev/null | cut -f1 || echo '0')"
echo "Pacman cache: $(du -sh /var/cache/pacman/pkg 2>/dev/null | cut -f1 || echo '0')"
echo "Core dumps: $(du -sh /var/lib/systemd/coredump 2>/dev/null | cut -f1 || echo '0')"
echo "Journal logs: $(journalctl --disk-usage 2>/dev/null | grep -oP '[\d.]+[GMK]' || echo 'N/A')"
echo ""
echo "Orphaned packages: $(pacman -Qdt 2>/dev/null | wc -l)"
```

Ask the user which items they want to clean up, then run the appropriate commands:
- Yay cache: `yay -Sc` (interactive)
- Pacman cache: `sudo paccache -rk2` (keep 2 versions)
- Core dumps: `sudo coredumpctl clean --keep=10`
- Journal: `sudo journalctl --vacuum-size=100M`
- Orphans: `sudo pacman -Rns $(pacman -Qdtq)` (if any)
