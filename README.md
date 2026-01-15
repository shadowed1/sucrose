<p align="center">
  <img src="https://i.imgur.com/6mhVqb5.png" alt="logo" width="1000" />
</p>

### A ChromeOS daemon to enable sudo in crosh shell.
<br>

### How to install:


- Requires developer mode. 

- Press `ctrl-alt-t`, open a crosh `shell` and paste:

<pre>bash <(curl -s "https://raw.githubusercontent.com/shadowed1/sucrose/main/bin/sucrose_downloader.sh?$(date +%s)")</pre>

<br>

### How to use:

- After installing, open VT-2 (ctrl-alt-refresh), log in as chronos, and run:
`sudo sucrose-daemon` and let it run. 

- Leave VT-2 (ctrl-alt-back) and sudo should now be enabled in crosh shell!

### How does this work? 

- Uses `mkfifo` for bidirectional communication between crosh shell and VT-2 when prepending `sucrose` or `sudo` to command. 
- The daemon uses `read` to passively wait for use of its fifo before it replies back.
- Fully atomic and ephemeral without any buffer.
- Enter VT-2, log in as chronos, and run `sudo sucrose_uninstaller` to uninstall.
- Dynamically creates/removes sudo alias if sudo is disabled. 

<br>

To enable sudo in crosh natively, check out sudoCrosh:
https://github.com/shadowed1/sudoCrosh
