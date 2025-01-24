class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  before_action :check_db_connection
  skip_before_action :check_db_connection, only: [ :reconnect_db ]

  def disconnect_db
    ActiveRecord::Base.connection_handler.clear_all_connections!
    redirect_to db_connection_error_path, notice: "База данных отключена."
  end

  def reconnect_db
    begin
      Rails.logger.info "Закрываем все текущие соединения..."
      ActiveRecord::Base.connection_handler.clear_all_connections!

      Rails.logger.info "Устанавливаем новое соединение..."
      ActiveRecord::Base.establish_connection

      Rails.logger.info "Добавляем задержку перед проверкой подключения..."

      Rails.logger.info "Проверяем, успешно ли восстановлено подключение..."
      ActiveRecord::Base.connection.execute("SELECT 1")
      Rails.logger.info "Подключение к базе данных восстановлено."
      redirect_to root_path, notice: "Подключение к базе данных восстановлено."
    rescue => e
      Rails.logger.error "Ошибка при повторном подключении к базе данных: #{e.message}"
      redirect_to db_connection_error_path, alert: "Не удалось подключиться к базе данных: #{e.message}"
    end
  end

  private

  def check_db_connection
    unless ActiveRecord::Base.connected?
      redirect_to db_connection_error_path, alert: "База данных отключена."
    end
  rescue ActiveRecord::ConnectionNotEstablished
    redirect_to db_connection_error_path, alert: "База данных отключена."
  end
end
