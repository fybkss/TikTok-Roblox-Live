from aiohttp import web

queue = []


async def add_player(request):
    data = await request.json()

    # Default data kalau field belum dikirim
    player = {
        "name": data.get("name", ""),
        "type": data.get("type", "follow"),
        "gift": data.get("gift", ""),
        "aura": data.get("aura", "Shadow"),
        "scale": data.get("scale", 1),
        "cinematic": data.get("cinematic", 0)
    }

    queue.append(player)

    print("===================================")
    print("Masuk Queue")
    print(player)
    print("===================================")

    return web.json_response({
        "status": "ok",
        "queue": len(queue)
    })


async def get_queue(request):

    if len(queue) == 0:
        return web.json_response(None)

    player = queue.pop(0)

    print("===================================")
    print("Kirim ke Roblox")
    print(player)
    print("===================================")

    return web.json_response(player)


async def home(request):
    return web.Response(text="TikTok Bot Server Aktif!")


app = web.Application()

app.router.add_get("/", home)
app.router.add_post("/add", add_player)
app.router.add_get("/queue", get_queue)

if __name__ == "__main__":
    web.run_app(
        app,
        host="127.0.0.1",
        port=5000
    )