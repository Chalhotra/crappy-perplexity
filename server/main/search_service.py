from tavily import TavilyClient
import trafilatura
tavily_client = TavilyClient(api_key="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")

class SearchServices:
    def web_search(self, query: str):

        results = []

        response = tavily_client.search(query, max = 10)

        search_results = response.get("results", [])

        # downloaded = [{"title": results[i].get("title", ""), "content": trafilatura.fetch_url(results.get("url", ""))} for i in results]
        for result in search_results:
            downloaded = trafilatura.fetch_url(result.get("url"))
            content  = trafilatura.extract(downloaded, include_comments=False)

            results.append(
                {
                    "title": result.get("title", ""),
                    "url": result.get("url", ""),
                    "content": content 
                }
            )
        return results






        
