import asyncio
from fastapi import FastAPI, WebSocket
from search_service import SearchServices
from chat_model import ChatBody
from llm_services import LLMServices
from sort_services import SortResultServices



app = FastAPI()

search_services = SearchServices()
sort_results_services = SortResultServices()
llm_services = LLMServices()

@app.websocket("/ws/chat")
async def websocket_chat_endpoint(websocket: WebSocket):
    await asyncio.sleep(0.2)
    await websocket.accept()
    try:
        await asyncio.sleep(0.2)
        data = await websocket.receive_json()
        query = data['query']
        print(query)
        downloaded = search_services.web_search(query)
        print(downloaded)
        sorted_results = sort_results_services.sort_results(query, downloaded)
        await asyncio.sleep(0.2)
        await websocket.send_json({"type": "search_results", "data": sorted_results})
        
        for chunk in llm_services.search_results(query=query, content=sorted_results):
            await asyncio.sleep(0.2)
            await websocket.send_json({"type": "content", "data": chunk})

        
    except Exception as e:
        print(e)
    finally:
        await websocket.close()


@app.post("/chat")


def chat_post(body: ChatBody):

    downloaded = search_services.web_search((body.query))
    print(downloaded)
    sorted_results = sort_results_services.sort_results((body.query), downloaded)

    llm_results = llm_services.search_results((body.query), sorted_results)
    return llm_results



