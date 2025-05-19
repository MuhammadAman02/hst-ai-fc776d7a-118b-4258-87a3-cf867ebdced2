from fastapi import APIRouter, Depends, HTTPException
from typing import List, Optional
import logging

from app.models.ai_models import (
    HealthChatRequest, HealthChatResponse
)
from app.services.ai_services import HealthChatService

# Configure logging
logger = logging.getLogger(__name__)

# Create router
router = APIRouter()

# Service dependencies
def get_health_chat_service():
    """Dependency for Health Chat service."""
    return HealthChatService(model_name="health-gpt-3.5-turbo")

# Health Chatbot endpoint
@router.post("/health-chat", response_model=HealthChatResponse)
async def health_chat(
    request: HealthChatRequest,
    health_chat_service: HealthChatService = Depends(get_health_chat_service)
):
    """Health chatbot endpoint for health-related conversations."""
    try:
        return await health_chat_service.generate_response(request)
    except Exception as e:
        logger.error(f"Error in health chat endpoint: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))

# Keep other endpoints (chat, analyze, recommend, detect-fraud) as they were...