from pydantic import BaseModel, Field
from typing import List, Optional, Dict, Any
from datetime import datetime
import uuid

class HealthTopic(str):
    GENERAL = "general"
    NUTRITION = "nutrition"
    FITNESS = "fitness"
    MENTAL_HEALTH = "mental_health"
    FIRST_AID = "first_aid"

class HealthMessage(BaseModel):
    """Represents a single message in a health-related conversation."""
    content: str
    role: str = "user"  # "user" or "assistant"
    timestamp: datetime = Field(default_factory=datetime.now)
    topic: Optional[HealthTopic] = HealthTopic.GENERAL

class HealthConversation(BaseModel):
    """Represents a health-related conversation with multiple messages."""
    id: str = Field(default_factory=lambda: str(uuid.uuid4()))
    messages: List[HealthMessage] = []
    metadata: Optional[Dict[str, Any]] = None

class HealthChatRequest(BaseModel):
    """Request model for health chat operations."""
    message: str
    conversation_id: Optional[str] = None
    user_info: Optional[Dict[str, Any]] = None

class HealthChatResponse(BaseModel):
    """Response model for health chat operations."""
    response: str
    conversation_id: str
    topic: HealthTopic
    additional_info: Optional[Dict[str, Any]] = None