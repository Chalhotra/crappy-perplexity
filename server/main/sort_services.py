from typing import List
from sentence_transformers import SentenceTransformer
import numpy as np


class SortResultServices:
    def __init__(self):
        self.model = SentenceTransformer("all-MiniLM-L6-v2") 
    def sort_results(self, query: str, content: List[dict]):
        query_embedding = self.model.encode(query).tolist()  # Convert to list to make it JSON serializable
        for result in content:
            res_embedding = self.model.encode(result.get("content", "") or "").tolist()  # Convert to list
            norm_res = np.linalg.norm(res_embedding)
            norm_query = np.linalg.norm(query_embedding)
            if norm_res == 0 or norm_query == 0:
                similarity = 0.0
            else:
                similarity = float(np.dot(res_embedding, query_embedding) / max((norm_res * norm_query), 1e-9))
            result["similarity_index"] = similarity  # Ensure similarity is a float, not numpy.float32

        return sorted(content, key=lambda x: x["similarity_index"], reverse=True)