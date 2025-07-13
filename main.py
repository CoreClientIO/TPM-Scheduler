#!/usr/bin/env python3

import os
import sys
import time
import signal
import asyncio
from datetime import datetime, timedelta
from rich.console import Console
from rich.panel import Panel
from rich.prompt import Prompt
from rich.text import Text
from rich.table import Table
from rich.align import Align

from modules.config_manager import ConfigManager
from modules.screen_manager import ScreenManager
from modules.webhook_handler import WebhookHandler
from modules.duration_parser import DurationParser
from modules.logger import Logger


class TPMScheduler:
    def __init__(self):
        self.console = Console()
        self.config_manager = ConfigManager()
        self.screen_manager = ScreenManager()
        self.webhook_handler = WebhookHandler()
        self.duration_parser = DurationParser()
        self.logger = Logger()
        self.running = True

        signal.signal(signal.SIGINT, self._signal_handler)
        signal.signal(signal.SIGTERM, self._signal_handler)

    def _signal_handler(self, signum, frame):
        self.running = False
        self.console.print("\n[yellow]Gracefully shutting down...[/yellow]")
        sys.exit(0)

    def display_banner(self):
        banner = Text("CoreClient TPM-Scheduler", style="bold cyan")
        panel = Panel(
            Align.center(banner),
            border_style="bright_blue",
            padding=(1, 2)
        )
        self.console.print(panel)

    def display_status(self, cycle_duration, next_restart):
        table = Table(show_header=False, box=None, padding=(0, 2))
        table.add_row("[bold green]Status:[/bold green]", "[green]Running[/green]")
        table.add_row("[bold blue]Cycle Duration:[/bold blue]", f"[blue]{cycle_duration}[/blue]")
        table.add_row("[bold yellow]Next Restart:[/bold yellow]", f"[yellow]{next_restart}[/yellow]")

        panel = Panel(table, title="[bold]Current Status[/bold]", border_style="green")
        self.console.print(panel)

    async def run(self):
        self.console.clear()
        self.display_banner()

        config = self.config_manager.load_config()

        duration_input = config.get("cycle_duration", "1h")
        duration_seconds = self.duration_parser.parse(duration_input)
        if duration_seconds is None:
            self.console.print(f"[red]Invalid cycle_duration in config: {duration_input}. Use: 10s, 5m, 1h, etc.[/red]")
            return

        self.logger.info(f"Starting TPM-Scheduler with {duration_input} cycle")

        if config.get("webhook_url"):
            await self.webhook_handler.send_notification(
                config["webhook_url"],
                "TPM-Scheduler Started",
                f"The scheduler has started successfully!",
                0x00ff00,
                status="started",
                cycle_duration=duration_input,
                next_restart=datetime.now().strftime("%H:%M:%S")
            )

        while self.running:
            try:
                next_restart = datetime.now().strftime("%H:%M:%S")
                self.display_status(duration_input, next_restart)

                self.logger.info("Killing all screens")
                self.screen_manager.kill_all_screens()

                self.logger.info("Creating new TPM screen")
                self.screen_manager.create_screen(
                    config["screen_name"],
                    config["command"]
                )

                if config.get("webhook_url"):
                    await self.webhook_handler.send_notification(
                        config["webhook_url"],
                        "TPM Restarted",
                        f"A new TPM session has started.",
                        0x0099ff,
                        status="restarted",
                        cycle_duration=duration_input,
                        next_restart=(datetime.now() + timedelta(seconds=duration_seconds)).strftime("%H:%M:%S")
                    )

                self.logger.info(f"Sleeping for {duration_seconds} seconds")
                await asyncio.sleep(duration_seconds)

            except Exception as e:
                self.logger.error(f"Error in main loop: {e}")
                if config.get("webhook_url"):
                    await self.webhook_handler.send_notification(
                        config["webhook_url"],
                        "TPM Error",
                        f"An error occurred during the scheduler loop.",
                        0xFF0000,
                        status="error",
                        error=str(e)
                    )
                await asyncio.sleep(10)


if __name__ == "__main__":
    scheduler = TPMScheduler()
    asyncio.run(scheduler.run())