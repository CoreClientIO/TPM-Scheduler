import aiohttp
import json
from datetime import datetime
from .logger import Logger

class WebhookHandler:
    def __init__(self):
        self.logger = Logger()

    async def send_notification(self, webhook_url, title, description, color, status=None, cycle_duration=None, next_restart=None, error=None):
        if not webhook_url:
            return

        status_emoji = {
            'started': '✅',
            'restarted': '🔄',
            'error': '⚠️',
            'stopped': '🛑',
            None: 'ℹ️'
        }.get(status, 'ℹ️')

        fields = []
        def add_field(name, value, inline=True):
            fields.append({"name": name, "value": f"```{value}```", "inline": inline})

        if status:
            add_field("Status", f"{status_emoji} {status.title()}")
        if cycle_duration:
            add_field("Cycle Duration", f"⏱️ {cycle_duration}")
        if next_restart:
            add_field("Next Restart", f"🕒 {next_restart}")
        if error:
            add_field("Error", f"{error}", inline=False)

        embed = {
            "title": f"{status_emoji} {title}",
            "description": description,
            "color": 0xFFFFFF,
            "timestamp": datetime.utcnow().isoformat(),
            "footer": {
                "text": "CoreClient TPM-Scheduler",
                "icon_url": "https://avatars.githubusercontent.com/u/218497533?v=4"
            },
            "author": {
                "name": "CoreClient Scheduler by NonNull",
                "icon_url": "https://avatars.githubusercontent.com/u/218497533?v=4"
            },
            "fields": fields
        }

        payload = {
            "username": "CoreClient Scheduler",
            "avatar_url": "https://avatars.githubusercontent.com/u/218497533?v=4",
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