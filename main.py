from TikTokLive import TikTokLiveClient
from TikTokLive.events import ConnectEvent, CommentEvent, FollowEvent, GiftEvent
import time
import requests


client = TikTokLiveClient(unique_id="fybkss_")


SERVER_URL = "http://localhost:5000/add"


# Database supporter
supporters = {}


# Anti spam
MAX_SPAWN = 3
COOLDOWN = 5

spawn_count = {}
last_comment = {}


@client.on(ConnectEvent)
async def on_connect(event):
    print("===================================")
    print("✅ Bot Terhubung!")
    print("===================================")



# FOLLOW EVENT
@client.on(FollowEvent)
async def on_follow(event):

    user = event.user.unique_id

    supporters[user] = {
        "follow": True,
        "gift": 0,
        "priority": 1,
        "aura": "Shadow"
    }

    print("FOLLOW:", user)



# GIFT EVENT
@client.on(GiftEvent)
async def on_gift(event):

    user = event.user.unique_id
    gift = event.gift.name

    if user not in supporters:
        supporters[user] = {
            "follow": False,
            "gift": 0,
            "priority": 0,
            "aura": "Shadow"
        }


    supporters[user]["gift"] += 1


    # Tier gift
    if "Galaxy" in gift:
        supporters[user]["priority"] = 3
        supporters[user]["aura"] = "Fire"

    else:
        supporters[user]["priority"] = 2
        supporters[user]["aura"] = "Thunder"


    print("GIFT:", user)
    print("Gift:", gift)
    print("Priority:", supporters[user]["priority"])



# KOMEN
@client.on(CommentEvent)
async def on_comment(event):

    tiktok_user = event.user.unique_id
    roblox_user = event.comment.strip()

    now = time.time()


    if roblox_user == "":
        return


    # cek supporter
    if tiktok_user not in supporters:
        print("Bukan supporter:", tiktok_user)
        return


    # cooldown
    if tiktok_user in last_comment:
        if now - last_comment[tiktok_user] < COOLDOWN:
            return


    last_comment[tiktok_user] = now


    if spawn_count.get(tiktok_user,0) >= MAX_SPAWN:
        return


    spawn_count[tiktok_user] = spawn_count.get(tiktok_user,0)+1


    aura = supporters[tiktok_user]["aura"]
    priority = supporters[tiktok_user]["priority"]


    print("===================================")
    print("USER:", tiktok_user)
    print("ROBLOX:", roblox_user)
    print("AURA:", aura)
    print("PRIORITY:", priority)


    try:

        requests.post(
            SERVER_URL,
            json={
                "name": roblox_user,
                "aura": aura,
                "priority": priority
            }
        )

        print("Kirim Roblox berhasil")

    except Exception as e:
        print("ERROR:", e)



client.run()