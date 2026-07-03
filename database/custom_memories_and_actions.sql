-- Mobile Automation Agent Custom Memories & Actions Library
-- Pre-loaded knowledge base for enhanced agent decision-making

-- ============================================================================
-- CUSTOM WORKING MEMORY TEMPLATES
-- ============================================================================

INSERT INTO working_memory_task_context (session_id, task_objective, current_step, total_steps, completed_steps, pending_steps, filled_fields, current_screen_state, last_action, last_action_result, confidence_level)
VALUES 
    (gen_random_uuid(), 'Complete customer satisfaction survey', 1, 5, '[]', '["identify_questions", "fill_responses", "validate_data", "submit_form", "confirm_completion"]', '{}', '{"screen": "survey_intro", "title": "Customer Satisfaction Survey", "button_count": 1}', 'navigate_to_survey', 'success', 0.98),
    (gen_random_uuid(), 'Test login flow and authentication', 1, 4, '[]', '["enter_credentials", "verify_mfa", "check_dashboard", "logout"]', '{"username": "test_user"}', '{"screen": "login", "elements": ["email_field", "password_field", "login_button"]}', 'app_launch', 'success', 0.95),
    (gen_random_uuid(), 'Complete product feedback form', 1, 3, '[]', '["extract_form_fields", "fill_ratings", "submit_feedback"]', '{}', '{"screen": "feedback_form", "questions": 8}', 'form_detection', 'success', 0.92);

-- ============================================================================
-- CUSTOM EPISODIC MEMORIES - SUCCESSFUL PATTERNS
-- ============================================================================

INSERT INTO episodic_memory (agent_id, episode_type, episode_name, episode_description, outcome, key_learnings, success_rate, execution_time_seconds)
VALUES 
    (
        gen_random_uuid(),
        'survey_completion',
        'NPS Survey with Conditional Follow-up',
        'Completed NPS survey with 1-10 rating and conditional text follow-up for scores < 7',
        'success',
        '{
            "pattern": "Conditional fields appear based on rating score",
            "strategy": "Wait 500ms after rating selection for follow-up field to appear",
            "validation": "Check hidden attribute before attempting interaction",
            "response_generation": "Neutral to positive feedback for low scores, enthusiastic for high scores"
        }'::jsonb,
        0.98,
        245
    ),
    (
        gen_random_uuid(),
        'survey_completion',
        'Multi-page Survey Navigation',
        'Successfully navigated 3-page survey with Next buttons and progress indicators',
        'success',
        '{
            "pattern": "Multi-page forms with Next/Back buttons",
            "strategy": "Parse progress indicator to determine current page position",
            "navigation": "Scroll to bottom before clicking Next button",
            "wait_strategy": "Wait for page transition animation (300-500ms)"
        }'::jsonb,
        0.96,
        320
    ),
    (
        gen_random_uuid(),
        'app_testing',
        'Login Flow with Error Recovery',
        'Tested login with invalid credentials, error handling, and successful retry',
        'success',
        '{
            "error_detection": "Red text error message indicates validation failure",
            "recovery": "Clear fields and retry with valid credentials",
            "timing": "Error messages appear within 500ms of form submission",
            "accessibility": "Error text announced via accessibility service"
        }'::jsonb,
        0.94,
        180
    ),
    (
        gen_random_uuid(),
        'error_recovery',
        'Network Timeout Recovery',
        'Recovered from network timeout by waiting and retrying request',
        'success',
        '{
            "trigger": "HTTP 504 timeout after 30 seconds",
            "detection": "Error dialog with \"Retry\" button appeared",
            "strategy": "Wait 3 seconds, tap Retry button, proceed normally",
            "success_rate": 0.85
        }'::jsonb,
        0.85,
        45
    );

-- ============================================================================
-- CUSTOM EPISODIC PATTERNS - RECOGNIZED UI PATTERNS
-- ============================================================================

INSERT INTO episodic_patterns (agent_id, pattern_type, pattern_name, pattern_description, occurrences, success_count, failure_count)
VALUES 
    (
        gen_random_uuid(),
        'ui_interaction',
        'Material Design Rating Bar',
        'Horizontal rating bar with 1-5 stars for satisfaction/quality ratings',
        15,
        15,
        0
    ),
    (
        gen_random_uuid(),
        'ui_interaction',
        'Dropdown with Search Field',
        'Dropdown menu that filters options as you type for country/state selection',
        12,
        11,
        1
    ),
    (
        gen_random_uuid(),
        'ui_interaction',
        'Radio Button Group for Multiple Choice',
        'Vertical list of radio buttons for mutually exclusive options',
        28,
        28,
        0
    ),
    (
        gen_random_uuid(),
        'error_sequence',
        'Rate Limit Error with Exponential Backoff',
        'HTTP 429 error indicating too many requests, requires exponential backoff retry',
        5,
        5,
        0
    ),
    (
        gen_random_uuid(),
        'success_workflow',
        'Standard Survey Completion Flow',
        'Navigate -> Detect -> Fill -> Validate -> Submit -> Confirm',
        42,
        41,
        1
    );

-- ============================================================================
-- CUSTOM ERROR RECOVERY STRATEGIES
-- ============================================================================

INSERT INTO episodic_error_recovery (agent_id, error_type, recovery_strategy, strategy_success_rate, times_attempted, times_successful)
VALUES 
    (
        gen_random_uuid(),
        'app_crash',
        'Force close and relaunch app from home screen',
        0.92,
        25,
        23
    ),
    (
        gen_random_uuid(),
        'network_timeout',
        'Exponential backoff retry: 1s, 2s, 4s, 8s',
        0.88,
        40,
        35
    ),
    (
        gen_random_uuid(),
        'validation_error',
        'Parse error message, adjust input format, retry',
        0.95,
        60,
        57
    ),
    (
        gen_random_uuid(),
        'element_not_visible',
        'Scroll up/down to reveal element, wait 500ms, retry tap',
        0.91,
        35,
        32
    ),
    (
        gen_random_uuid(),
        'captcha_detected',
        'Escalate to human - cannot bypass ethically',
        0.0,
        8,
        0
    ),
    (
        gen_random_uuid(),
        'permission_denied',
        'Grant permission via system dialog, retry action',
        0.97,
        18,
        17
    );

-- ============================================================================
-- SEMANTIC MEMORY - FIELD TYPE LIBRARY
-- ============================================================================

INSERT INTO semantic_memory_field_types (field_type_name, field_category, validation_rules, example_values, auto_generation_rules)
VALUES 
    (
        'email',
        'contact',
        '{"pattern": "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", "required": true}'::jsonb,
        '["test@example.com", "user@domain.co.uk", "name+tag@mail.com"]'::jsonb,
        '{"format": "[random_string]@[test_domain].com", "domains": ["gmail.com", "yahoo.com", "example.com"]}'::jsonb
    ),
    (
        'phone',
        'contact',
        '{"pattern": "^\\+?[1-9]\\d{1,14}$", "min_length": 10, "max_length": 15}'::jsonb,
        '["+1-555-123-4567", "555-987-6543", "(555) 123-4567"]'::jsonb,
        '{"format": "(555) XXX-XXXX", "country_codes": ["+1", "+44", "+91"]}'::jsonb
    ),
    (
        'age',
        'personal',
        '{"type": "integer", "min": 13, "max": 120, "required": true}'::jsonb,
        '["25", "42", "67"]'::jsonb,
        '{"distribution": "normal", "mean": 40, "range": [18, 75]}'::jsonb
    ),
    (
        'date',
        'temporal',
        '{"format": "MM/DD/YYYY", "type": "date"}'::jsonb,
        '["01/15/1990", "12/25/2000", "06/30/1985"]'::jsonb,
        '{"format": "MM/DD/YYYY", "min_years_ago": 18, "max_years_ago": 80}'::jsonb
    ),
    (
        'zip_code',
        'address',
        '{"pattern": "^\\d{5}(?:-\\d{4})?$", "us_only": true}'::jsonb,
        '["90210", "10001", "60601-1234"]'::jsonb,
        '{"format": "NNNNN", "valid_ranges": [[10001, 99950]]}'::jsonb
    ),
    (
        'rating_1_5',
        'survey',
        '{"type": "integer", "min": 1, "max": 5, "required": true}'::jsonb,
        '["1", "3", "5"]'::jsonb,
        '{"distribution": "positive_skew", "weights": {"1": 0.05, "2": 0.05, "3": 0.15, "4": 0.35, "5": 0.40}}'::jsonb
    ),
    (
        'satisfaction_text',
        'survey',
        '{"type": "text", "min_length": 10, "max_length": 500}'::jsonb,
        '["The app is user-friendly and responsive", "Great features but needs improvement", "Exceeded my expectations"]'::jsonb,
        '{"templates": ["[positive_adjective] application with good [feature]", "Works well overall, could improve [area]"], "sentiment": "positive"}'::jsonb
    ),
    (
        'nps_score',
        'survey',
        '{"type": "integer", "min": 0, "max": 10, "required": true}'::jsonb,
        '["9", "10", "8"]'::jsonb,
        '{"distribution": "promoter_heavy", "weights": {"0-6": 0.10, "7-8": 0.20, "9-10": 0.70}}'::jsonb
    );

-- ============================================================================
-- SEMANTIC MEMORY - UI COMPONENT BEHAVIORS
-- ============================================================================

INSERT INTO semantic_memory_ui_components (component_type, framework, expected_behaviors, interaction_patterns, reliable_locators)
VALUES 
    (
        'Material Button',
        'material_design',
        '{
            "ripple_effect": true,
            "min_touch_target": 48,
            "state_feedback": "color_change_and_elevation",
            "animation_duration_ms": 200
        }'::jsonb,
        '{
            "primary_action": "tap_center",
            "double_tap": "double_activation",
            "long_press": "context_menu",
            "disabled_state": "tap_results_no_change"
        }'::jsonb,
        '[
            {"strategy": "accessibility_id", "priority": 1},
            {"strategy": "resource_id", "priority": 2},
            {"strategy": "text_content", "priority": 3},
            {"strategy": "xpath", "priority": 4}
        ]'::jsonb
    ),
    (
        'EditText (TextInputLayout)',
        'material_design',
        '{
            "focused_state": "underline_color_change_to_primary",
            "error_state": "red_underline_with_error_text",
            "character_counter": "shown_below_field",
            "hint_animation": "float_up_on_focus"
        }'::jsonb,
        '{
            "tap_to_focus": "position_at_end_of_text",
            "clear_button": "appears_when_focused",
            "password_toggle": "appears_for_password_fields",
            "autocomplete": "dropdown_below_field"
        }'::jsonb,
        '[
            {"strategy": "hint_text", "priority": 1},
            {"strategy": "resource_id", "priority": 2},
            {"strategy": "xpath_with_type", "priority": 3}
        ]'::jsonb
    ),
    (
        'RadioButton Group',
        'material_design',
        '{
            "mutual_exclusivity": true,
            "selection_animation": "circle_fill_animation",
            "ripple_on_entire_row": true,
            "vertical_or_horizontal": "either"
        }'::jsonb,
        '{
            "tap_anywhere_on_row": "selects_option",
            "already_selected": "no_change_on_tap",
            "keyboard_nav": "arrow_keys_cycle_options"
        }'::jsonb,
        '[
            {"strategy": "accessibility_id", "priority": 1},
            {"strategy": "text_content", "priority": 2},
            {"strategy": "xpath", "priority": 3}
        ]'::jsonb
    ),
    (
        'Spinner (Dropdown)',
        'android_native',
        '{
            "modal_popup": "appears_at_center",
            "list_scrollable": true,
            "animation_duration_ms": 300,
            "selection_closes_immediately": true
        }'::jsonb,
        '{
            "tap_spinner": "opens_popup_list",
            "tap_option": "selects_and_closes",
            "outside_tap": "closes_without_selection",
            "scroll_to_find": "option_not_visible"
        }'::jsonb,
        '[
            {"strategy": "accessibility_id", "priority": 1},
            {"strategy": "resource_id", "priority": 2},
            {"strategy": "xpath", "priority": 3}
        ]'::jsonb
    );

-- ============================================================================
-- SEMANTIC MEMORY - STANDARD WORKFLOWS
-- ============================================================================

INSERT INTO semantic_memory_workflows (workflow_name, workflow_category, workflow_steps, expected_duration_seconds, success_rate_baseline)
VALUES 
    (
        'Linear Survey Completion',
        'survey_completion',
        '{
            "steps": [
                {"step": 1, "name": "navigate_to_survey", "wait_ms": 1000},
                {"step": 2, "name": "extract_questions", "wait_ms": 500},
                {"step": 3, "name": "fill_each_question", "wait_ms": 800},
                {"step": 4, "name": "validate_all_fields", "wait_ms": 300},
                {"step": 5, "name": "submit_survey", "wait_ms": 1000},
                {"step": 6, "name": "confirm_completion", "wait_ms": 500}
            ]
        }'::jsonb,
        320,
        0.96
    ),
    (
        'Multi-page Form with Navigation',
        'form_completion',
        '{
            "steps": [
                {"step": 1, "name": "detect_page_indicator", "wait_ms": 500},
                {"step": 2, "name": "fill_current_page_fields", "wait_ms": 800},
                {"step": 3, "name": "locate_next_button", "wait_ms": 300},
                {"step": 4, "name": "scroll_to_button", "wait_ms": 200},
                {"step": 5, "name": "tap_next_button", "wait_ms": 1000},
                {"step": 6, "name": "wait_page_transition", "wait_ms": 500}
            ]
        }'::jsonb,
        600,
        0.94
    ),
    (
        'Login with Error Handling',
        'authentication',
        '{
            "steps": [
                {"step": 1, "name": "detect_login_screen", "wait_ms": 500},
                {"step": 2, "name": "fill_username", "wait_ms": 300},
                {"step": 3, "name": "fill_password", "wait_ms": 300},
                {"step": 4, "name": "tap_login", "wait_ms": 2000},
                {"step": 5, "name": "check_error_or_success", "wait_ms": 500},
                {"step": 6, "name": "handle_error_if_present", "wait_ms": 1000}
            ]
        }'::jsonb,
        240,
        0.92
    ),
    (
        'Conditional Field Survey',
        'survey_completion',
        '{
            "steps": [
                {"step": 1, "name": "answer_initial_question", "wait_ms": 500},
                {"step": 2, "name": "wait_for_conditional_field", "wait_ms": 1000},
                {"step": 3, "name": "detect_new_field", "wait_ms": 500},
                {"step": 4, "name": "fill_conditional_field", "wait_ms": 600},
                {"step": 5, "name": "validate_and_continue", "wait_ms": 400}
            ]
        }'::jsonb,
        280,
        0.91
    );

-- ============================================================================
-- SEMANTIC MEMORY - DECISION HEURISTICS
-- ============================================================================

INSERT INTO semantic_memory_heuristics (heuristic_name, heuristic_category, description, rule_conditions, rule_actions, priority, success_rate)
VALUES 
    (
        'Confidence Threshold Action Selection',
        'action_selection',
        'Execute action if confidence >= 0.85, request confirmation if 0.6-0.84, escalate if < 0.6',
        '{
            "confidence_score": {"operator": ">=", "value": 0.6},
            "action_identified": true
        }'::jsonb,
        '{
            "if_confidence_high": "execute_immediately",
            "if_confidence_medium": "request_human_confirmation",
            "if_confidence_low": "escalate_and_log"
        }'::jsonb,
        10,
        0.97
    ),
    (
        'Retry Strategy for Transient Errors',
        'error_recovery',
        'For transient errors (timeouts, temporary failures), retry with exponential backoff up to 3 times',
        '{
            "error_type": ["timeout", "connection_reset", "service_unavailable"],
            "recovery_attempts": {"less_than": 3}
        }'::jsonb,
        '{
            "wait_times_ms": [100, 500, 2000],
            "log_each_attempt": true,
            "escalate_if_all_fail": true
        }'::jsonb,
        9,
        0.88
    ),
    (
        'Element Visibility Pre-check',
        'safe_interaction',
        'Before tapping any element, verify it is visible and accessible',
        '{
            "action_type": "tap",
            "element_exists": true
        }'::jsonb,
        '{
            "check_visibility": true,
            "check_accessibility": true,
            "scroll_if_needed": true,
            "wait_if_animating": 500
        }'::jsonb,
        10,
        0.99
    ),
    (
        'Field Type Detection and Response Generation',
        'data_generation',
        'Automatically detect field type from label/hint and generate appropriate test data',
        '{
            "field_recognized": true,
            "field_type_in_database": true
        }'::jsonb,
        '{
            "retrieve_field_type": "from_semantic_memory",
            "generate_data": "according_to_rules",
            "validate_format": true,
            "log_generation": true
        }'::jsonb,
        8,
        0.94
    ),
    (
        'Network Error Backoff Strategy',
        'error_recovery',
        'When network errors occur, increase wait time exponentially and consider device offline',
        '{
            "error_type": ["network_timeout", "no_internet", "dns_failure"],
            "attempts": {"less_than": 5}
        }'::jsonb,
        '{
            "wait_base_ms": 1000,
            "backoff_multiplier": 2,
            "max_wait_ms": 30000,
            "log_network_state": true
        }'::jsonb,
        8,
        0.85
    ),
    (
        'Form Validation Error Parsing',
        'validation_handling',
        'Parse form validation errors to understand what correction is needed',
        '{
            "action_type": "submit_form",
            "error_detected": true,
            "error_message_present": true
        }'::jsonb,
        '{
            "extract_error_text": true,
            "identify_problematic_field": true,
            "determine_correction": "from_error_message",
            "modify_input": true,
            "retry_submission": true
        }'::jsonb,
        9,
        0.96
    );

-- ============================================================================
-- CUSTOM WORKING MEMORY DECISION POINTS
-- ============================================================================

INSERT INTO working_memory_decision_points (session_id, decision_type, available_choices, scores, selected_choice, reasoning)
VALUES 
    (
        gen_random_uuid(),
        'element_interaction_strategy',
        '{
            "choice_1": "tap_element_center",
            "choice_2": "tap_element_top_left",
            "choice_3": "scroll_and_retry"
        }'::jsonb,
        '{
            "choice_1": 0.95,
            "choice_2": 0.60,
            "choice_3": 0.50
        }'::jsonb,
        'tap_element_center',
        'Element is visible and center tap is most reliable for this button type'
    ),
    (
        gen_random_uuid(),
        'error_recovery_path',
        '{
            "choice_1": "immediate_retry",
            "choice_2": "wait_and_retry",
            "choice_3": "alternative_method",
            "choice_4": "escalate"
        }'::jsonb,
        '{
            "choice_1": 0.30,
            "choice_2": 0.92,
            "choice_3": 0.50,
            "choice_4": 0.20
        }'::jsonb,
        'wait_and_retry',
        'Network timeout detected - exponential backoff strategy is most effective'
    ),
    (
        gen_random_uuid(),
        'field_fill_strategy',
        '{
            "choice_1": "direct_text_input",
            "choice_2": "dropdown_selection",
            "choice_3": "date_picker",
            "choice_4": "radio_button"
        }'::jsonb,
        '{
            "choice_1": 0.30,
            "choice_2": 0.88,
            "choice_3": 0.15,
            "choice_4": 0.60
        }'::jsonb,
        'dropdown_selection',
        'Field label indicates country selection - dropdown interaction pattern is optimal'
    );

-- ============================================================================
-- CUSTOM PROSPECTIVE MEMORY GOALS
-- ============================================================================

INSERT INTO prospective_memory_goals (session_id, goal_type, goal_description, target_state, current_progress, deadline)
VALUES 
    (
        gen_random_uuid(),
        'immediate',
        'Fill all visible survey questions',
        '{
            "all_questions_answered": true,
            "all_validations_passed": true,
            "ready_for_submission": true
        }'::jsonb,
        45.0,
        CURRENT_TIMESTAMP + INTERVAL '5 minutes'
    ),
    (
        gen_random_uuid(),
        'intermediate',
        'Complete multi-page form navigation',
        '{
            "current_page": 3,
            "total_pages": 3,
            "all_pages_filled": true,
            "submission_ready": true
        }'::jsonb,
        66.0,
        CURRENT_TIMESTAMP + INTERVAL '10 minutes'
    ),
    (
        gen_random_uuid(),
        'final',
        'Successfully submit task and receive confirmation',
        '{
            "form_submitted": true,
            "server_acknowledged": true,
            "confirmation_message": "visible",
            "task_status": "completed"
        }'::jsonb,
        75.0,
        CURRENT_TIMESTAMP + INTERVAL '15 minutes'
    );

-- ============================================================================
-- MEMORY ACCESS PATTERNS FOR OPTIMIZATION
-- ============================================================================

INSERT INTO memory_access_patterns (agent_id, memory_table, access_type, query_pattern, frequency_per_hour, average_latency_ms, cache_beneficial)
VALUES 
    (
        gen_random_uuid(),
        'semantic_memory_field_types',
        'read',
        'SELECT * FROM semantic_memory_field_types WHERE field_type_name = ?',
        45.0,
        2.5,
        true
    ),
    (
        gen_random_uuid(),
        'semantic_memory_heuristics',
        'read',
        'SELECT * FROM semantic_memory_heuristics WHERE heuristic_category = ? ORDER BY priority DESC',
        32.0,
        3.2,
        true
    ),
    (
        gen_random_uuid(),
        'episodic_patterns',
        'read',
        'SELECT * FROM episodic_patterns WHERE agent_id = ? AND pattern_type = ? ORDER BY occurrences DESC',
        28.0,
        4.1,
        false
    ),
    (
        gen_random_uuid(),
        'episodic_memory',
        'write',
        'INSERT INTO episodic_memory (agent_id, episode_type, ...) VALUES (...)',
        15.0,
        5.3,
        false
    ),
    (
        gen_random_uuid(),
        'working_memory',
        'read_write',
        'Complex session-based queries with frequent updates',
        120.0,
        1.8,
        true
    );

-- ============================================================================
-- CUSTOM ACTIONS LOG TEMPLATES
-- ============================================================================

INSERT INTO actions (session_id, action_number, action_type, target_element_id, parameters, pre_execution_state, post_execution_state, execution_time_ms, success)
VALUES 
    (
        gen_random_uuid(),
        1,
        'tap',
        gen_random_uuid(),
        '{
            "coordinates": {"x": 540, "y": 800},
            "element_type": "button",
            "element_text": "Start Survey"
        }'::jsonb,
        '{
            "screen_state": "ready",
            "button_visible": true,
            "button_enabled": true
        }'::jsonb,
        '{
            "navigation_triggered": true,
            "new_screen": "survey_questions",
            "transition_animation": "slide_left"
        }'::jsonb,
        245,
        true
    ),
    (
        gen_random_uuid(),
        2,
        'type',
        gen_random_uuid(),
        '{
            "target_field": "email_field",
            "text_to_enter": "test.user@example.com",
            "keystroke_delay_ms": 50,
            "clear_before_typing": true
        }'::jsonb,
        '{
            "field_focused": false,
            "field_empty": true,
            "keyboard_hidden": true
        }'::jsonb,
        '{
            "field_focused": true,
            "text_entered": "test.user@example.com",
            "keyboard_shown": true,
            "field_validation": "pending"
        }'::jsonb,
        320,
        true
    ),
    (
        gen_random_uuid(),
        3,
        'scroll',
        NULL,
        '{
            "direction": "down",
            "distance_dp": 500,
            "animation_duration_ms": 400,
            "target_element_text": "Submit Button"
        }'::jsonb,
        '{
            "scroll_position": 0,
            "submit_button_visible": false,
            "content_height": 2000
        }'::jsonb,
        '{
            "scroll_position": 500,
            "submit_button_visible": true,
            "new_content_loaded": true
        }'::jsonb,
        410,
        true
    );

-- ============================================================================
-- MEMORY CONSOLIDATION EXAMPLES
-- ============================================================================

INSERT INTO memory_consolidation_log (agent_id, consolidation_type, source_memories, confidence_after_consolidation, learning_insights)
VALUES 
    (
        gen_random_uuid(),
        'episodic_to_semantic',
        '["episode_1", "episode_2", "episode_3", "episode_4", "episode_5"]'::jsonb,
        0.94,
        'Pattern recognized: All conditional field surveys follow same 500-1000ms wait pattern. Confidence in detecting and waiting for conditional fields increased from 0.78 to 0.94'
    ),
    (
        gen_random_uuid(),
        'pattern_extraction',
        '["pattern_1", "pattern_2", "pattern_3"]'::jsonb,
        0.91,
        'Extracted: Material Design rating bars always use circular selection animation. Success rate for rating selection improved from 0.88 to 0.99'
    ),
    (
        gen_random_uuid(),
        'heuristic_refinement',
        '["recovery_attempt_1", "recovery_attempt_2", "recovery_attempt_3"]'::jsonb,
        0.89,
        'Network timeout recovery: Exponential backoff strategy refined. Initial wait 500ms -> 1s -> 2s. Success rate improved from 0.81 to 0.92'
    );

-- ============================================================================
-- MEMORY ASSOCIATIONS
-- ============================================================================

INSERT INTO memory_associations (agent_id, primary_memory_id, primary_memory_type, associated_memory_id, associated_memory_type, association_strength, association_type, context)
VALUES 
    (
        gen_random_uuid(),
        gen_random_uuid(),
        'semantic',
        gen_random_uuid(),
        'episodic',
        0.95,
        'causal',
        '{"relationship": "Email field validation always requires format verification before submission"}'::jsonb
    ),
    (
        gen_random_uuid(),
        gen_random_uuid(),
        'semantic',
        gen_random_uuid(),
        'episodic',
        0.92,
        'similar',
        '{"relationship": "All survey pages with progress indicators follow same wait-and-scroll pattern"}'::jsonb
    ),
    (
        gen_random_uuid(),
        gen_random_uuid(),
        'working',
        gen_random_uuid(),
        'prospective',
        0.98,
        'hierarchical',
        '{"relationship": "Current form-fill action is prerequisite for upcoming validation step"}'::jsonb
    );

-- ============================================================================
-- MEMORY HEALTH METRICS BASELINE
-- ============================================================================

INSERT INTO memory_health_metrics (agent_id, measurement_date, working_memory_entries, episodic_memory_entries, semantic_memory_entries, prospective_memory_entries, average_retrieval_latency_ms, cache_hit_rate_percent, consolidation_events)
VALUES 
    (
        gen_random_uuid(),
        CURRENT_DATE,
        12,
        156,
        89,
        8,
        2.8,
        87.5,
        3
    ),
    (
        gen_random_uuid(),
        CURRENT_DATE,
        8,
        142,
        89,
        6,
        3.1,
        85.2,
        2
    ),
    (
        gen_random_uuid(),
        CURRENT_DATE,
        15,
        168,
        89,
        10,
        2.5,
        89.3,
        4
    );

-- ============================================================================
-- CREATE INDEXES FOR CUSTOM MEMORIES
-- ============================================================================

CREATE INDEX idx_episodic_memory_success_rate ON episodic_memory(success_rate DESC);
CREATE INDEX idx_episodic_patterns_occurrences ON episodic_patterns(occurrences DESC);
CREATE INDEX idx_semantic_field_types_category ON semantic_memory_field_types(field_category);
CREATE INDEX idx_semantic_heuristics_priority ON semantic_memory_heuristics(priority DESC, success_rate DESC);
CREATE INDEX idx_working_memory_task_context ON working_memory_task_context(session_id);
CREATE INDEX idx_prospective_goals_progress ON prospective_memory_goals(current_progress DESC);

-- ============================================================================
-- END OF CUSTOM MEMORIES AND ACTIONS
-- ============================================================================
