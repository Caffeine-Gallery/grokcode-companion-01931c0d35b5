import { backend } from 'declarations/backend';

let apiKey = '';

document.getElementById('save-api-key').addEventListener('click', async () => {
    const apiKeyInput = document.getElementById('api-key');
    apiKey = apiKeyInput.value.trim();

    if (apiKey) {
        try {
            await backend.setApiKey(apiKey);
            document.getElementById('api-key-form').style.display = 'none';
            document.getElementById('chat-interface').style.display = 'block';
        } catch (error) {
            console.error('Error saving API key:', error);
            alert('Failed to save API key. Please try again.');
        }
    } else {
        alert('Please enter a valid API key.');
    }
});

document.getElementById('send-message').addEventListener('click', async () => {
    const userInput = document.getElementById('user-input');
    const message = userInput.value.trim();

    if (message) {
        addMessageToChat('You', message);
        userInput.value = '';

        try {
            const response = await backend.sendMessageToGrok(message);
            addMessageToChat('Grok', response);
        } catch (error) {
            console.error('Error sending message to Grok:', error);
            addMessageToChat('System', 'Error: Failed to get response from Grok.');
        }
    }
});

function addMessageToChat(sender, message) {
    const chatMessages = document.getElementById('chat-messages');
    const messageElement = document.createElement('div');
    messageElement.className = 'mb-2';
    messageElement.innerHTML = `<strong>${sender}:</strong> ${message}`;
    chatMessages.appendChild(messageElement);
    chatMessages.scrollTop = chatMessages.scrollHeight;
}
