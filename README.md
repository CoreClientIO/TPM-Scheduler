# <img src="/assets/banner.png" alt="CoreClient TPM-Scheduler" width="100%"/>

<p align="center">
  <a href="https://github.com/CoreClientIO/TPM-Scheduler"><img src="https://img.shields.io/github/stars/CoreClientIO/TPM-Scheduler?style=flat-square" alt="Stars"></a>
  <a href="https://github.com/CoreClientIO/TPM-Scheduler"><img src="https://img.shields.io/github/license/CoreClientIO/TPM-Scheduler?style=flat-square" alt="License"></a>
  <a href="https://img.shields.io/badge/python-3.7%2B-blue?style=flat-square"><img src="https://img.shields.io/badge/python-3.7%2B-blue?style=flat-square" alt="Python"></a>
  <a href="https://discord.gg/VSBBfr5UTZ"><img src="https://img.shields.io/discord/1249726936425443378?label=Discord&logo=discord&style=flat-square" alt="Discord"></a>
</p>

<h1 align="center">CoreClient TPM-Scheduler</h1>

<p align="center">
  <b>A beautiful, robust process scheduler for TPM-loader-linux.<br>
  Automatic restarts, Discord webhooks, and a modern console UI.<br>
  <i>Programmed by NonNull</i></b>
</p>

---

## <img src="https://avatars.githubusercontent.com/u/218497533?v=4" width="32"/> Features

- 🔄 **Automatic restarts** with customizable duration
- 🎨 **Rich console interface** with beautiful formatting
- 📊 **Real-time status display**
- 🔔 **Discord webhook notifications** (white style, emoji, avatar, status)
- 📝 **Comprehensive logging**
- ⚙️ **JSON configuration management**
- 🛡️ **Graceful shutdown handling**
- 📦 **Modular, production-ready architecture**
- 🚀 **Standalone Linux executable** (no Python needed at runtime)

---

## <img src="https://cdn-icons-png.flaticon.com/512/25/25231.png" width="24"/> Installation

```bash
git clone https://github.com/CoreClientIO/TPM-Scheduler.git
cd TPM-Scheduler
chmod +x setup.sh
./setup.sh
```

Everything is automated. The binary will be ready to use as `./tpm-scheduler`.

---

## 🤖 Automated Service Setup (Recommended)

For 24/7 operation, run:

```bash
./setup_service.sh
```

This will:
- Move the binary to `/usr/local/bin/`
- Create and enable a systemd service
- Start the scheduler in the background
- Show you all the commands you need for management

---

## 🖥️ Usage

**From Source:**
```bash
python main.py
```

**From Executable:**
```bash
./tpm-scheduler
```

---

## ⚙️ Configuration

On first run, a `config.json` will be created. You can edit it to customize:

```json
{
    "screen_name": "TPM",
    "command": "./TPM-loader-linux",
    "webhook_url": "https://discord.com/api/webhooks/...",
    "log_level": "INFO",
    "log_file": "tpm-scheduler.log",
    "cycle_duration": "1h"
}
```
- `cycle_duration` supports formats like `10s`, `5m`, `1h`, `1d`.
- No more prompts on every start: just set your duration in the config!

---

## 🛠️ How it Works

```mermaid
graph TD;
    A[Start Scheduler] --> B{Load config.json};
    B -->|No config| C[Prompt for webhook, create config];
    B -->|Config exists| D[Read settings];
    D --> E[Start TPM-loader in screen];
    E --> F[Send Discord webhook];
    F --> G[Wait for cycle_duration];
    G --> E;
    E -->|Error| H[Send error webhook];
```

---

## 📸 Screenshots

<p align="center">
  <img src="/assets/screenshot1.png" alt="Console UI" width="600"/>
  <br>
  <i>Modern, beautiful status panel</i>
</p>
<p align="center">
  <img src="/assets/webhook_example.png" alt="Discord Webhook" width="500"/>
  <br>
  <i>White-style Discord webhook with emoji, avatar, and status</i>
</p>

---

## 🖥️ Service Management

After running `./setup_service.sh`, you can:

- **Restart:**
  ```bash
  sudo systemctl restart tpm-scheduler
  ```
- **Stop:**
  ```bash
  sudo systemctl stop tpm-scheduler
  ```
- **Start:**
  ```bash
  sudo systemctl start tpm-scheduler
  ```
- **Status:**
  ```bash
  systemctl status tpm-scheduler
  ```
- **Logs:**
  ```bash
  journalctl -u tpm-scheduler -f
  ```

---

## 📝 Logs

All activities are logged to `tpm-scheduler.log` with timestamps and details.

---

## 💬 Community & Support

- [GitHub Issues](https://github.com/CoreClientIO/TPM-Scheduler/issues)
- [Discord Support](https://discord.gg/VSBBfr5UTZ)

For issues and support, check the logs in `tpm-scheduler.log` for detailed error information.

---

## 🪪 License

This project is part of the CoreClient ecosystem. See [LICENSE](LICENSE).

---

<p align="center">
  <b>Made with ❤️ by NonNull & the CoreClient team</b>
</p>