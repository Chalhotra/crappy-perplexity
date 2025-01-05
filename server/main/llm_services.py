import google.generativeai as genai
from typing import List
GEMINI_API_KEY = 'AIzaSyB1POqgz0cuqAM2hBLsnbmpNthOGZY8fmg'


genai.configure(api_key = GEMINI_API_KEY)

model = genai.GenerativeModel("gemini-2.0-flash-exp")


class LLMServices:
    def search_results(self, query: str, content: List[dict]):
        pintu = f"query: {query}"
        context_text = "\n\n".join(
            [
                f"Source {i+1} ({result['url']}):\n{result['content']}"
                for i, result in enumerate(content)
            ]
        )

        full_prompt = f"""
        Context from web search:
        {context_text}

        Query: {query}

        Please provide a comprehensive, detailed, well-cited accurate response using the above context. 
        Think and reason deeply. Ensure it answers the query the user is asking. Do not use your knowledge until it is absolutely necessary.
        """


        full_prompt+= pintu 

        response = model.generate_content(full_prompt, stream=True)

        for chunk in response:
            yield chunk.text

