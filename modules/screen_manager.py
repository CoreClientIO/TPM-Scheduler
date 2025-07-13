import subprocess
import os
from .logger import Logger

class ScreenManager:
    def __init__(self):
        self.logger = Logger()

    def kill_all_screens(self):
        try:
            subprocess.run(["pkill", "screen"], check=False)
            self.logger.info("All screens killed")
        except Exception as e:
            self.logger.error(f"Error killing screens: {e}")

    def create_screen(self, name, command):
        try:
            subprocess.run([
                "screen", "-dmS", name, "bash", "-c", command
            ], check=True)
            self.logger.info(f"Created screen '{name}' with command '{command}'")
        except subprocess.CalledProcessError as e:
            self.logger.error(f"Error creating screen: {e}")
            raise

    def list_screens(self):
        try:
            result = subprocess.run(
                ["screen", "-ls"],
                capture_output=True,
                text=True
            )
            return result.stdout
        except Exception as e:
            self.logger.error(f"Error listing screens: {e}")
            return ""