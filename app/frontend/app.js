// API Configuration - will be replaced by backend URL
const API_URL = window.location.hostname === 'localhost'
    ? 'http://localhost:3000/api'
    : `http://${window.BACKEND_IP || 'backend'}:3000/api`;

// State
let todos = [];
let currentFilter = 'all';

// DOM Elements
const todoForm = document.getElementById('todo-form');
const todoInput = document.getElementById('todo-input');
const todoList = document.getElementById('todo-list');
const filterBtns = document.querySelectorAll('.filter-btn');
const todoCount = document.getElementById('todo-count');
const clearCompletedBtn = document.getElementById('clear-completed');
const loadingEl = document.getElementById('loading');
const errorEl = document.getElementById('error-message');

// Initialize app
document.addEventListener('DOMContentLoaded', () => {
    loadTodos();
    setupEventListeners();
});

// Setup event listeners
function setupEventListeners() {
    todoForm.addEventListener('submit', handleAddTodo);
    clearCompletedBtn.addEventListener('click', handleClearCompleted);

    filterBtns.forEach(btn => {
        btn.addEventListener('click', () => {
            currentFilter = btn.dataset.filter;
            filterBtns.forEach(b => b.classList.remove('active'));
            btn.classList.add('active');
            renderTodos();
        });
    });
}

// Show/hide loading
function showLoading(show = true) {
    loadingEl.style.display = show ? 'block' : 'none';
}

// Show error message
function showError(message) {
    errorEl.textContent = message;
    errorEl.style.display = 'block';
    setTimeout(() => {
        errorEl.style.display = 'none';
    }, 5000);
}

// Load todos from API
async function loadTodos() {
    showLoading(true);
    try {
        const response = await fetch(`${API_URL}/todos`);
        if (!response.ok) throw new Error('Failed to load todos');

        todos = await response.json();
        renderTodos();
    } catch (error) {
        console.error('Error loading todos:', error);
        showError('Failed to load todos. Please check if the backend is running.');
    } finally {
        showLoading(false);
    }
}

// Add new todo
async function handleAddTodo(e) {
    e.preventDefault();

    const title = todoInput.value.trim();
    if (!title) return;

    try {
        const response = await fetch(`${API_URL}/todos`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ title })
        });

        if (!response.ok) throw new Error('Failed to create todo');

        const newTodo = await response.json();
        todos.unshift(newTodo);
        todoInput.value = '';
        renderTodos();

        // Add celebratory animation
        todoInput.style.transform = 'scale(1.05)';
        setTimeout(() => {
            todoInput.style.transform = 'scale(1)';
        }, 200);
    } catch (error) {
        console.error('Error adding todo:', error);
        showError('Failed to add todo. Please try again.');
    }
}

// Toggle todo completion
async function handleToggleTodo(id, completed) {
    try {
        const response = await fetch(`${API_URL}/todos/${id}`, {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ completed: !completed })
        });

        if (!response.ok) throw new Error('Failed to update todo');

        const updatedTodo = await response.json();
        todos = todos.map(todo => todo.id === id ? updatedTodo : todo);
        renderTodos();
    } catch (error) {
        console.error('Error toggling todo:', error);
        showError('Failed to update todo. Please try again.');
    }
}

// Delete todo
async function handleDeleteTodo(id) {
    try {
        const response = await fetch(`${API_URL}/todos/${id}`, {
            method: 'DELETE'
        });

        if (!response.ok) throw new Error('Failed to delete todo');

        todos = todos.filter(todo => todo.id !== id);
        renderTodos();
    } catch (error) {
        console.error('Error deleting todo:', error);
        showError('Failed to delete todo. Please try again.');
    }
}

// Clear completed todos
async function handleClearCompleted() {
    const completedTodos = todos.filter(todo => todo.completed);

    if (completedTodos.length === 0) return;

    try {
        await Promise.all(
            completedTodos.map(todo =>
                fetch(`${API_URL}/todos/${todo.id}`, { method: 'DELETE' })
            )
        );

        todos = todos.filter(todo => !todo.completed);
        renderTodos();
    } catch (error) {
        console.error('Error clearing completed todos:', error);
        showError('Failed to clear completed todos. Please try again.');
    }
}

// Filter todos based on current filter
function getFilteredTodos() {
    switch (currentFilter) {
        case 'active':
            return todos.filter(todo => !todo.completed);
        case 'completed':
            return todos.filter(todo => todo.completed);
        default:
            return todos;
    }
}

// Render todos to DOM
function renderTodos() {
    const filteredTodos = getFilteredTodos();

    if (filteredTodos.length === 0) {
        todoList.innerHTML = `
            <div class="empty-state">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" 
                          d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
                </svg>
                <p>${currentFilter === 'completed' ? 'No completed todos' :
                currentFilter === 'active' ? 'No active todos' :
                    'No todos yet. Add one above!'}</p>
            </div>
        `;
    } else {
        todoList.innerHTML = filteredTodos.map(todo => `
            <li class="todo-item ${todo.completed ? 'completed' : ''}" data-id="${todo.id}">
                <input 
                    type="checkbox" 
                    class="todo-checkbox" 
                    ${todo.completed ? 'checked' : ''}
                    onchange="handleToggleTodo(${todo.id}, ${todo.completed})"
                >
                <span class="todo-text">${escapeHtml(todo.title)}</span>
                <button class="delete-btn" onclick="handleDeleteTodo(${todo.id})">×</button>
            </li>
        `).join('');
    }

    // Update stats
    const activeCount = todos.filter(todo => !todo.completed).length;
    todoCount.textContent = `${activeCount} ${activeCount === 1 ? 'item' : 'items'} left`;

    // Show/hide clear button
    const hasCompleted = todos.some(todo => todo.completed);
    clearCompletedBtn.style.opacity = hasCompleted ? '1' : '0.5';
    clearCompletedBtn.style.pointerEvents = hasCompleted ? 'auto' : 'none';
}

// Escape HTML to prevent XSS
function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

// Health check
async function checkBackendHealth() {
    try {
        const response = await fetch(`${API_URL.replace('/api', '')}/health`);
        if (response.ok) {
            console.log('✅ Backend is healthy');
        }
    } catch (error) {
        console.log('⚠️ Backend health check failed:', error);
    }
}

// Run health check on load
checkBackendHealth();
