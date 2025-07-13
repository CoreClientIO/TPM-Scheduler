import json
import os
from rich.console import Console
from rich.prompt import Prompt


class ConfigManager:
    def __init__(self):
        self.config_file = "config.json"
        self.console = Console()
        self.default_config = {
            "screen_name": "TPM",
            "command": "./TPM-loader-linux",
            "webhook_url": "",
            "log_level": "INFO",
            "log_file": "tpm-scheduler.log",
            "cycle_duration": "1h"
        }

    def load_config(self):
        if not os.path.exists(self.config_file):
            return self.create_config()

        try:
            with open(self.config_file, 'r') as f:
                config = json.load(f)
            # Always ensure cycle_duration is present
            if "cycle_duration" not in config:
                config["cycle_duration"] = self.default_config["cycle_duration"]
            return {**self.default_config, **config}
        except Exception as e:
            self.console.print(f"[red]Error loading config: {e}[/red]")
            return self.create_config()

    def create_config(self):
        self.console.print("[yellow]Config file not found. Creating new configuration...[/yellow]")

        webhook_url = Prompt.ask(
            "[bold cyan]Enter Discord webhook URL[/bold cyan]",
            default="",
            show_default=False
        )

        config = self.default_config.copy()
        config["webhook_url"] = webhook_url

        with open(self.config_file, 'w') as f:
            json.dump(config, f, indent=4)

        self.console.print(f"[green]Config created: {self.config_file}[/green]")
        return config

    def save_config(self, config):
        with open(self.config_file, 'w') as f:
            json.dump(config, f, indent=4)