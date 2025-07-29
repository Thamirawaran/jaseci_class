import streamlit as st
import requests
import json

st.set_page_config(page_title="Agentic Task Manager", page_icon="📋")

st.title("📋 Agentic Task Manager")
st.write("Enter a task description and let the AI agent help you manage it!")

# Input section
task_description = st.text_area(
    "Task Description",
    placeholder="e.g., 'Create a task to review the quarterly report by Friday' or 'Summarize all pending tasks'",
    height=100
)

if st.button("Execute", type="primary"):
    if task_description.strip():
        with st.spinner("Processing your request..."):
            try:
                # Make request to TaskManager endpoint
                response = requests.post(
                    "http://localhost:8000/walker/TaskManager",
                    json={"question": task_description}
                )
                
                if response.status_code == 200:
                    result = response.json()
                    
                    st.success("✅ Request processed successfully!")
                    
                    # Display the response
                    if isinstance(result, dict):
                        if "name" in result and "description" in result:
                            # CreateTaskTool response - display as task card
                            st.subheader("🆕 New Task Created")
                            col1, col2 = st.columns(2)
                            
                            with col1:
                                st.write(f"**Name:** {result.get('name', 'N/A')}")
                                st.write(f"**Status:** {result.get('status', 'N/A')}")
                            
                            with col2:
                                st.write(f"**Due Date:** {result.get('dueDate', 'N/A')}")
                                st.write(f"**Assigned To:** {result.get('assignedTo', 'N/A')}")
                            
                            st.write(f"**Description:** {result.get('description', 'N/A')}")
                        
                        else:
                            # Other structured response
                            st.json(result)
                    
                    elif isinstance(result, str):
                        # SummariseTool response or plain text
                        st.subheader("📊 Summary")
                        st.write(result)
                    
                    else:
                        # Fallback for other response types
                        st.write("**Response:**")
                        st.json(result)
                
                else:
                    st.error(f"❌ Error: {response.status_code} - {response.text}")
            
            except requests.exceptions.ConnectionError:
                st.error("❌ Could not connect to the TaskManager service. Please ensure it's running on http://localhost:8000")
            
            except Exception as e:
                st.error(f"❌ An error occurred: {str(e)}")
    
    else:
        st.warning("⚠️ Please enter a task description")

# Sidebar with information
with st.sidebar:
    st.header("ℹ️ How it works")
    st.write("""
    1. **Enter a task description** in the text area
    2. The AI agent will analyze your input
    3. It will choose the appropriate tool:
       - **CreateTaskTool**: For creating new tasks
       - **SummariseTool**: For summarizing existing tasks
    4. View the results below
    """)
    
    st.header("📝 Example Inputs")
    st.write("""
    **For creating tasks:**
    - "Create a task to prepare presentation for Monday"
    - "Add a task to call client by end of week"
    
    **For summarizing:**
    - "Show me all pending tasks"
    - "Summarize tasks assigned to John"
    """)
    
    st.header("🔧 Service Status")
    try:
        health_response = requests.get("http://localhost:8000/", timeout=2)
        if health_response.status_code == 200:
            st.success("✅ Service is running")
        else:
            st.error("❌ Service issue")
    except:
        st.error("❌ Service offline")
