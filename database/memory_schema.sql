-- Mobile Automation Agent Memory System
-- Multi-layered memory for learning and adaptation

-- Working Memory (Session Duration)
CREATE TABLE IF NOT EXISTS working_memory (
    memory_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id UUID NOT NULL REFERENCES sessions(session_id) ON DELETE CASCADE,
    agent_id UUID NOT NULL REFERENCES agents(agent_id),
    memory_type VARCHAR(100),
    key VARCHAR(255),
    value JSONB,
    expires_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Episodic Memory (7 Days)
CREATE TABLE IF NOT EXISTS episodic_memory (
    episode_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    agent_id UUID NOT NULL REFERENCES agents(agent_id),
    episode_type VARCHAR(100),
    episode_name VARCHAR(255),
    outcome VARCHAR(50),
    success_rate DECIMAL(5, 2),
    key_learnings JSONB,
    retention_until TIMESTAMP DEFAULT CURRENT_TIMESTAMP + INTERVAL '7 days',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Episodic Patterns
CREATE TABLE IF NOT EXISTS episodic_patterns (
    pattern_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    agent_id UUID NOT NULL REFERENCES agents(agent_id),
    pattern_type VARCHAR(100),
    pattern_name VARCHAR(255),
    occurrences INTEGER DEFAULT 1,
    success_count INTEGER,
    failure_count INTEGER,
    retention_until TIMESTAMP DEFAULT CURRENT_TIMESTAMP + INTERVAL '7 days',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Episodic Error Recovery
CREATE TABLE IF NOT EXISTS episodic_error_recovery (
    recovery_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    agent_id UUID NOT NULL REFERENCES agents(agent_id),
    error_type VARCHAR(100),
    recovery_strategy VARCHAR(100),
    strategy_success_rate DECIMAL(5, 2),
    times_attempted INTEGER,
    times_successful INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Semantic Memory - App Knowledge
CREATE TABLE IF NOT EXISTS semantic_memory_app_knowledge (
    knowledge_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    app_name VARCHAR(255) NOT NULL,
    knowledge_category VARCHAR(100),
    knowledge_key VARCHAR(255),
    knowledge_value JSONB,
    confidence_score DECIMAL(5, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Semantic Memory - Field Types
CREATE TABLE IF NOT EXISTS semantic_memory_field_types (
    field_type_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    field_type_name VARCHAR(100) NOT NULL UNIQUE,
    field_category VARCHAR(100),
    validation_rules JSONB,
    example_values JSONB,
    auto_generation_rules JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Semantic Memory - UI Components
CREATE TABLE IF NOT EXISTS semantic_memory_ui_components (
    component_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    component_type VARCHAR(100) NOT NULL,
    framework VARCHAR(100),
    expected_behaviors JSONB,
    interaction_patterns JSONB,
    reliable_locators JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Semantic Memory - Workflows
CREATE TABLE IF NOT EXISTS semantic_memory_workflows (
    workflow_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    workflow_name VARCHAR(255) NOT NULL UNIQUE,
    workflow_category VARCHAR(100),
    workflow_steps JSONB,
    success_rate_baseline DECIMAL(5, 2),
    execution_count INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Semantic Memory - Heuristics
CREATE TABLE IF NOT EXISTS semantic_memory_heuristics (
    heuristic_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    heuristic_name VARCHAR(255) NOT NULL UNIQUE,
    heuristic_category VARCHAR(100),
    description TEXT,
    rule_conditions JSONB,
    rule_actions JSONB,
    priority INTEGER,
    success_rate DECIMAL(5, 2),
    usage_count INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Prospective Memory
CREATE TABLE IF NOT EXISTS prospective_memory (
    prospective_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id UUID NOT NULL REFERENCES sessions(session_id) ON DELETE CASCADE,
    memory_type VARCHAR(100),
    trigger_condition JSONB,
    trigger_time TIMESTAMP,
    action_to_take VARCHAR(500),
    status VARCHAR(50) DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Prospective Memory Goals
CREATE TABLE IF NOT EXISTS prospective_memory_goals (
    goal_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id UUID NOT NULL REFERENCES sessions(session_id) ON DELETE CASCADE,
    goal_type VARCHAR(100),
    goal_description VARCHAR(500),
    current_progress DECIMAL(5, 2),
    deadline TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Memory Health Metrics
CREATE TABLE IF NOT EXISTS memory_health_metrics (
    metric_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    agent_id UUID NOT NULL REFERENCES agents(agent_id),
    measurement_date DATE,
    working_memory_entries INTEGER,
    episodic_memory_entries INTEGER,
    semantic_memory_entries INTEGER,
    average_retrieval_latency_ms DECIMAL(8, 2),
    cache_hit_rate_percent DECIMAL(5, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Memory Consolidation Log
CREATE TABLE IF NOT EXISTS memory_consolidation_log (
    consolidation_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    agent_id UUID NOT NULL REFERENCES agents(agent_id),
    consolidation_type VARCHAR(100),
    source_memories JSONB,
    result_memory_id UUID,
    confidence_after_consolidation DECIMAL(5, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Memory Associations
CREATE TABLE IF NOT EXISTS memory_associations (
    association_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    agent_id UUID NOT NULL REFERENCES agents(agent_id),
    primary_memory_id UUID,
    associated_memory_id UUID,
    association_strength DECIMAL(5, 2),
    association_type VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Views for memory analysis
CREATE OR REPLACE VIEW memory_learning_insights AS
SELECT 
    agent_id,
    consolidation_type,
    COUNT(*) as consolidation_count,
    AVG(confidence_after_consolidation) as avg_confidence
FROM memory_consolidation_log
WHERE created_at > CURRENT_TIMESTAMP - INTERVAL '7 days'
GROUP BY agent_id, consolidation_type;

CREATE OR REPLACE VIEW frequent_patterns_by_agent AS
SELECT 
    agent_id,
    pattern_type,
    pattern_name,
    occurrences,
    success_count,
    ROUND(100.0 * success_count / NULLIF(occurrences, 0), 2) as success_rate_percent
FROM episodic_patterns
ORDER BY agent_id, occurrences DESC;

CREATE OR REPLACE VIEW error_recovery_effectiveness AS
SELECT 
    agent_id,
    error_type,
    recovery_strategy,
    times_attempted,
    times_successful,
    ROUND(100.0 * times_successful / NULLIF(times_attempted, 0), 2) as success_rate_percent
FROM episodic_error_recovery
ORDER BY agent_id, success_rate_percent DESC;
