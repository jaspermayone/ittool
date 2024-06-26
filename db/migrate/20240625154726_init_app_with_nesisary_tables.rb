class InitAppWithNesisaryTables < ActiveRecord::Migration[7.1]
  def change
    create_table :solid_queue_jobs do |t|
      t.string :queue_name, null: false
      t.string :class_name, null: false, index: true
      t.text :arguments
      t.integer :priority, default: 0, null: false
      t.string :active_job_id, index: true
      t.datetime :scheduled_at
      t.datetime :finished_at, index: true
      t.string :concurrency_key

      t.timestamps

      t.index [ :queue_name, :finished_at ], name: "index_solid_queue_jobs_for_filtering"
      t.index [ :scheduled_at, :finished_at ], name: "index_solid_queue_jobs_for_alerting"
    end

    create_table :solid_queue_scheduled_executions do |t|
      t.references :job, index: { unique: true }, null: false
      t.string :queue_name, null: false
      t.integer :priority, default: 0, null: false
      t.datetime :scheduled_at, null: false

      t.datetime :created_at, null: false

      t.index [ :scheduled_at, :priority, :job_id ], name: "index_solid_queue_dispatch_all"
    end

    create_table :solid_queue_ready_executions do |t|
      t.references :job, index: { unique: true }, null: false
      t.string :queue_name, null: false
      t.integer :priority, default: 0, null: false

      t.datetime :created_at, null: false

      t.index [ :priority, :job_id ], name: "index_solid_queue_poll_all"
      t.index [ :queue_name, :priority, :job_id ], name: "index_solid_queue_poll_by_queue"
    end

    create_table :solid_queue_claimed_executions do |t|
      t.references :job, index: { unique: true }, null: false
      t.bigint :process_id
      t.datetime :created_at, null: false

      t.index [ :process_id, :job_id ]
    end

    create_table :solid_queue_blocked_executions do |t|
      t.references :job, index: { unique: true }, null: false
      t.string :queue_name, null: false
      t.integer :priority, default: 0, null: false
      t.string :concurrency_key, null: false
      t.datetime :expires_at, null: false

      t.datetime :created_at, null: false

      t.index [ :expires_at, :concurrency_key ], name: "index_solid_queue_blocked_executions_for_maintenance"
    end

    create_table :solid_queue_failed_executions do |t|
      t.references :job, index: { unique: true }, null: false
      t.text :error
      t.datetime :created_at, null: false
    end

    create_table :solid_queue_pauses do |t|
      t.string :queue_name, null: false, index: { unique: true }
      t.datetime :created_at, null: false
    end

    create_table :solid_queue_processes do |t|
      t.string :kind, null: false
      t.datetime :last_heartbeat_at, null: false, index: true
      t.bigint :supervisor_id, index: true

      t.integer :pid, null: false
      t.string :hostname
      t.text :metadata

      t.datetime :created_at, null: false
    end

    create_table :solid_queue_semaphores do |t|
      t.string :key, null: false, index: { unique: true }
      t.integer :value, default: 1, null: false
      t.datetime :expires_at, null: false, index: true

      t.timestamps

      t.index [ :key, :value ], name: "index_solid_queue_semaphores_on_key_and_value"
    end

    add_foreign_key :solid_queue_blocked_executions, :solid_queue_jobs, column: :job_id, on_delete: :cascade
    add_foreign_key :solid_queue_claimed_executions, :solid_queue_jobs, column: :job_id, on_delete: :cascade
    add_foreign_key :solid_queue_failed_executions, :solid_queue_jobs, column: :job_id, on_delete: :cascade
    add_foreign_key :solid_queue_ready_executions, :solid_queue_jobs, column: :job_id, on_delete: :cascade
    add_foreign_key :solid_queue_scheduled_executions, :solid_queue_jobs, column: :job_id, on_delete: :cascade
    add_index :solid_queue_blocked_executions, [ :concurrency_key, :priority, :job_id ], name: "index_solid_queue_blocked_executions_for_release"

    create_table :solid_queue_recurring_executions do |t|
      t.references :job, index: { unique: true }, null: false
      t.string :task_key, null: false
      t.datetime :run_at, null: false
      t.datetime :created_at, null: false

      t.index [ :task_key, :run_at ], unique: true
    end

    add_foreign_key :solid_queue_recurring_executions, :solid_queue_jobs, column: :job_id, on_delete: :cascade

    create_table :console1984_sessions do |t|
      t.text :reason
      t.references :user, null: false, index: false
      t.timestamps

      t.index :created_at
      t.index [ :user_id, :created_at ]
    end

    create_table :console1984_users do |t|
      t.string :username, null: false
      t.timestamps

      t.index [:username]
    end

    create_table :console1984_commands do |t|
      t.text :statements
      t.references :sensitive_access
      t.references :session, null: false, index: false
      t.timestamps

      t.index [ :session_id, :created_at, :sensitive_access_id ], name: "on_session_and_sensitive_chronologically"
    end

    create_table :console1984_sensitive_accesses do |t|
      t.text :justification
      t.references :session, null: false

      t.timestamps
    end

    create_table :audits1984_audits do |t|
      t.integer :status, default: 0, null: false
      t.text :notes
      t.references :session, null: false
      t.references :auditor, null: false

      t.timestamps
    end

    # Use Active Record's configured type for primary and foreign keys
    primary_key_type, foreign_key_type = primary_and_foreign_key_types

    create_table :active_storage_blobs, id: primary_key_type do |t|
      t.string   :key,          null: false
      t.string   :filename,     null: false
      t.string   :content_type
      t.text     :metadata
      t.string   :service_name, null: false
      t.bigint   :byte_size,    null: false
      t.string   :checksum

      if connection.supports_datetime_with_precision?
        t.datetime :created_at, precision: 6, null: false
      else
        t.datetime :created_at, null: false
      end

      t.index [ :key ], unique: true
    end

    create_table :active_storage_attachments, id: primary_key_type do |t|
      t.string     :name,     null: false
      t.references :record,   null: false, polymorphic: true, index: false, type: foreign_key_type
      t.references :blob,     null: false, type: foreign_key_type

      if connection.supports_datetime_with_precision?
        t.datetime :created_at, precision: 6, null: false
      else
        t.datetime :created_at, null: false
      end

      t.index [ :record_type, :record_id, :name, :blob_id ], name: :index_active_storage_attachments_uniqueness, unique: true
      t.foreign_key :active_storage_blobs, column: :blob_id
    end

    create_table :active_storage_variant_records, id: primary_key_type do |t|
      t.belongs_to :blob, null: false, index: false, type: foreign_key_type
      t.string :variation_digest, null: false

      t.index [ :blob_id, :variation_digest ], name: :index_active_storage_variant_records_uniqueness, unique: true
      t.foreign_key :active_storage_blobs, column: :blob_id
    end
  end

  private
  def primary_and_foreign_key_types
    config = Rails.configuration.generators
    setting = config.options[config.orm][:primary_key_type]
    primary_key_type = setting || :primary_key
    foreign_key_type = setting || :bigint
    [primary_key_type, foreign_key_type]
  end
end
