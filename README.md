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

Clone the repository:
```
git clone https://github.com/your-org/TPM-Scheduler.git
cd TPM-Scheduler
```
Make the setup script executable:
```
chmod +x setup.sh
```
Run the setup script:
```
./setup.sh
```

Everything is automated. The binary will be ready to use as `./tpm-scheduler`.

## Usage

**From Source:**
```
python main.py
```

**From Executable:**
```
./tpm-scheduler
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

```
{
    "screen_name": "TPM",
    "command": "./TPM-loader-linux",
    "webhook_url": "https://discord.com/api/webhooks/...",
    "log_level": "INFO",
    "log_file": "tpm-scheduler.log"
}
```

## Project Structure

```
tpm-scheduler/
├── main.py                 
├── modules/
│   ├── init.py
│   ├── config_manager.py   
│   ├── screen_manager.py   
│   ├── webhook_handler.py  
│   ├── duration_parser.py  
│   └── logger.py          
├── requirements.txt
├── tpm-scheduler.spec      
├── README.md
└── dist/
└── tpm-scheduler       
```

## Deployment

The built executable is self-contained and can be deployed to any Linux system without requiring Python or dependencies to be installed.

### Quick Deployment

1. Build the executable on your development machine
2. Copy `./tpm-scheduler` to your target server
3. Make it executable: `chmod +x tpm-scheduler`
4. Run: `./tpm-scheduler`

## Logs

All activities are logged to tpm-scheduler.log with timestamps and detailed information.

## Discord Notifications

When configured, the scheduler sends branded embed notifications for:

- Scheduler startup
- Each restart cycle
- Error conditions
The embeds are styled with CoreClient branding and include:

- Timestamp
- Color-coded status (green for start, blue for restart)
- Footer with "CoreClient TPM-Scheduler"
- Author information

## Requirements

- Linux with screen command available
- Internet connection (for webhook notifications)
- Python 3.7+ (for building only)

## Troubleshooting

Screen command not found:
```
sudo apt-get install screen
```

Permission denied:
```
chmod +x tpm-scheduler
```

# License

This project is part of the CoreClient ecosystem.

# Support

For issues and support, please check the logs in tpm-scheduler.log for detailed error information.