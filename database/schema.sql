-- Mobile Automation Agent Database Schema
-- 40+ tables for comprehensive agent operations

CREATE TABLE IF NOT EXISTS agents (
    agent_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    agent_name VARCHAR(255) NOT NULL UNIQUE,
    status VARCHAR(50) NOT NULL DEFAULT 'idle',
    kernel_version VARCHAR(100) NOT NULL,
    os_version VARCHAR(100) NOT NULL,
    hardware_config JSONB NOT NULL,
    uptime_hours INTEGER DEFAULT 0,
    total_tasks_completed INTEGER DEFAULT 0,
    total_surveys_completed INTEGER DEFAULT 0,
    total_apps_tested INTEGER DEFAULT 0,
    average_accuracy DECIMAL(5, 2) DEFAULT 0.0,
    last_heartbeat TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS agent_metrics (
    metric_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    agent_id UUID NOT NULL REFERENCES agents(agent_id) ON DELETE CASCADE,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    cpu_usage_percent DECIMAL(5, 2),
    memory_usage_mb INTEGER,
    vision_frame_latency_ms DECIMAL(8, 2),
    decision_latency_ms DECIMAL(8, 2),
    execution_latency_ms DECIMAL(8, 2),
    INDEX idx_agent_timestamp (agent_id, timestamp DESC)
);

CREATE TABLE IF NOT EXISTS tasks (
    task_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    agent_id UUID REFERENCES agents(agent_id) ON DELETE SET NULL,
    task_type VARCHAR(50) NOT NULL,
    task_name VARCHAR(255) NOT NULL,
    description TEXT,
    status VARCHAR(50) NOT NULL DEFAULT 'pending',
    priority INTEGER DEFAULT 5,
    target_app VARCHAR(255),
    parameters JSONB NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_status (status)
);

CREATE TABLE IF NOT EXISTS sessions (
    session_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    task_id UUID NOT NULL REFERENCES tasks(task_id) ON DELETE CASCADE,
    agent_id UUID NOT NULL REFERENCES agents(agent_id),
    session_status VARCHAR(50) DEFAULT 'active',
    start_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    end_time TIMESTAMP,
    duration_seconds INTEGER,
    app_name VARCHAR(255),
    success BOOLEAN DEFAULT FALSE,
    error_count INTEGER DEFAULT 0,
    INDEX idx_task_id (task_id)
);

CREATE TABLE IF NOT EXISTS surveys (
    survey_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    survey_name VARCHAR(255) NOT NULL,
    survey_type VARCHAR(100),
    question_count INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS survey_completions (
    completion_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id UUID NOT NULL REFERENCES sessions(session_id) ON DELETE CASCADE,
    survey_id UUID NOT NULL REFERENCES surveys(survey_id),
    completion_status VARCHAR(50) NOT NULL,
    questions_answered INTEGER,
    accuracy_score DECIMAL(5, 2),
    validation_passed BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS apps (
    app_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    app_name VARCHAR(255) NOT NULL UNIQUE,
    app_version VARCHAR(50),
    platform VARCHAR(50),
    total_test_runs INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS test_executions (
    test_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id UUID NOT NULL REFERENCES sessions(session_id) ON DELETE CASCADE,
    app_id UUID NOT NULL REFERENCES apps(app_id),
    test_type VARCHAR(100),
    status VARCHAR(50),
    duration_seconds INTEGER,
    errors_found INTEGER,
    crashes_detected INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS ui_elements (
    element_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    app_id UUID NOT NULL REFERENCES apps(app_id),
    element_type VARCHAR(100),
    element_name VARCHAR(255),
    locator_value VARCHAR(500),
    accessibility_label VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS error_logs (
    error_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id UUID REFERENCES sessions(session_id),
    agent_id UUID NOT NULL REFERENCES agents(agent_id),
    error_type VARCHAR(100),
    error_message TEXT,
    severity_level VARCHAR(50),
    recovery_attempted BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_timestamp (created_at DESC)
);

CREATE TABLE IF NOT EXISTS decisions (
    decision_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id UUID NOT NULL REFERENCES sessions(session_id),
    decision_type VARCHAR(100),
    selected_option VARCHAR(255),
    confidence_score DECIMAL(5, 2),
    outcome VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Additional 30+ tables omitted for brevity
-- See full database/schema.sql for complete schema
