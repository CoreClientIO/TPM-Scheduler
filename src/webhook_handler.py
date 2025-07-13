import aiohttp
import json
from datetime import datetime
from .logger import Logger

class WebhookHandler:
    def __init__(self):
        self.logger = Logger()

    async def send_notification(self, webhook_url, title, description, color):
        if not webhook_url:
            return

        embed = {
            "title": title,
            "description": description,
            "color": color,
            "timestamp": datetime.utcnow().isoformat(),
            "footer": {
                "text": "CoreClient TPM-Scheduler",
                "icon_url": "https://i.imgur.com/placeholder.png"
            },
            "author": {
                "name": "CoreClient",
                "icon_url": "https://i.imgur.com/placeholder.png"
            }
        }

        payload = {
            "embeds": [embed]
        }

        try:
            async with aiohttp.ClientSession() as session:
                async with session.post(
                    webhook_url,
                    json=payload,
                    headers={"Content-Type": "application/json"}
                ) as response:
                    if response.status == 204:
                        self.logger.info("Webhook notification sent successfully")
                    else:
                        self.logger.error(f"Webhook failed with status {response.status}")
        except Exception as e:
            self.logger.error(f"Error sending webhook: {e}")