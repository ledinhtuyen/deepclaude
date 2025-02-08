"use client"

import { useState } from "react"
import { Chat } from "../../components/chat"
import { Settings } from "../../components/settings"

export default function ChatPage() {
  const [selectedModel, setSelectedModel] = useState("anthropic/claude-3.5-sonnet")
  const [apiTokens, setApiTokens] = useState({
    openRouterApiToken: "",
  })

  return (
    <main className="relative min-h-screen">
      <Settings 
        onSettingsChange={setApiTokens}
      />
      <Chat 
        selectedModel={selectedModel} 
        onModelChange={setSelectedModel}
        apiTokens={apiTokens}
      />
    </main>
  )
}
