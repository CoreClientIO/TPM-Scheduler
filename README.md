# CoreClient TPM-Scheduler

A sophisticated process scheduler for managing TPM-loader-linux with automatic restarts, webhook notifications, and beautiful console interface.

## Features

- 🔄 Automatic restart cycles with customizable duration
- 🎨 Beautiful console interface with rich formatting
- 📊 Real-time status display
- 🔔 Discord webhook notifications
- 📝 Comprehensive logging
- ⚙️ JSON configuration management
- 🛡️ Graceful shutdown handling
- 📦 Modular architecture
- 🚀 Compilable to standalone Linux executable

## Installation

### Option 1: Run from Source

1. Clone or download the project
2. Install dependencies:
```bash
pip install -r requirements.txt
```
3. Run directly:
```bash
python main.py
```

### Option 2: Build Executable

1. Install build dependencies:
```bash
pip install pyinstaller
```

2. Build the executable:
```bash
pyinstaller tpm-scheduler.spec
```

3. Run the executable:
```bash
./dist/tpm-scheduler
```

## Usage

### Basic Usage

**From Source:**
```bash
python main.py
```

**From Executable:**
```bash
./dist/tpm-scheduler
```

### First Run Setup

On first run, the scheduler will:
1. Create a `config.json` file
2. Prompt for Discord webhook URL (optional)
3. Use default settings for screen name and command

### Duration Format

The scheduler accepts various duration formats:
- `10s` - 10 seconds
- `5m` - 5 minutes  
- `2h` - 2 hours
- `1d` - 1 day

### Configuration

Edit `config.json` to customize:

```json
{
    "screen_name": "TPM",
    "command": "./TPM-loader-linux",
    "webhook_url": "https://discord.com/api/webhooks/...",
    "log_level": "INFO",
    "log_file": "tpm-scheduler.log"
}
```

## Building Executable

### Using Spec File (Recommended)

```bash
# Install PyInstaller
pip install pyinstaller

# Build using spec file
pyinstaller tpm-scheduler.spec

# Run the executable
./dist/tpm-scheduler
```

### Manual Build

```bash
pyinstaller --onefile \
    --name="tpm-scheduler" \
    --hidden-import=modules.config_manager \
    --hidden-import=modules.screen_manager \
    --hidden-import=modules.webhook_handler \
    --hidden-import=modules.duration_parser \
    --hidden-import=modules.logger \
    --add-data="modules:modules" \
    main.py
```

## Project Structure

```bash
tpm-scheduler/
├── main.py                 # Main application entry point
├── modules/
│   ├── init.py
│   ├── config_manager.py   # Configuration management
│   ├── screen_manager.py   # Screen session handling
│   ├── webhook_handler.py  # Discord webhook integration
│   ├── duration_parser.py  # Duration string parsing
│   └── logger.py          # Logging system
├── requirements.txt
├── tpm-scheduler.spec      # PyInstaller spec file
├── README.md
└── dist/
└── tpm-scheduler       # Linux executable (after build)
```

## Deployment

The built executable is self-contained and can be deployed to any Linux system without requiring Python or dependencies to be installed.

### Quick Deployment

1. Build the executable on your development machine
2. Copy `./dist/tpm-scheduler` to your target server
3. Make it executable: `chmod +x tpm-scheduler`
4. Run: `./tpm-scheduler`

### System Service (Optional)

Create a systemd service file `/etc/systemd/system/tpm-scheduler.service`:

```ini
[Unit]
Description=CoreClient TPM-Scheduler
After=network.target

[Service]
Type=simple
User=your-username
WorkingDirectory=/path/to/tpm-scheduler
ExecStart=/path/to/tpm-scheduler/dist/tpm-scheduler
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

Enable and start:

```bash
sudo systemctl enable tpm-scheduler
sudo systemctl start tpm-scheduler
```

# Logs

All activities are logged to tpm-scheduler.log with timestamps and detailed information.

# Discord Notifications

When configured, the scheduler sends branded embed notifications for:

- Scheduler startup
- Each restart cycle
- Error conditions
The embeds are styled with CoreClient branding and include:

- Timestamp
- Color-coded status (green for start, blue for restart)
- Footer with "CoreClient TPM-Scheduler"
- Author information

# Requirements

## Runtime Requirements

- Linux with screen command available
- Internet connection (for webhook notifications)

## Development Requirements

- Python 3.7+
- Dependencies listed in requirements.txt

## Build Requirements

- PyInstaller
- All runtime and development requirements

# Troubleshooting

## Common Issues

Screen command not found:

```bash
# Ubuntu/Debian
sudo apt-get install screen

# CentOS/RHEL
sudo yum install screen
```

Permission denied:
```bash
chmod +x tpm-scheduler
```

Module import errors:
Make sure all modules are properly included in the spec file and the build completed successfully.

# License

This project is part of the CoreClient ecosystem.

# Support

For issues and support, please check the logs in tpm-scheduler.log for detailed error information.