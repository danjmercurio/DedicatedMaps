#email stuff
Ddmap::Application.config.action_mailer.perform_deliveries = true
Ddmap::Application.config.action_mailer.delivery_method = :smtp
Ddmap::Application.config.action_mailer.smtp_settings = {
    address: 'smtp.gmail.com',
    port: 587,
    domain: 'dedicatedmaps.com',
    user_name: 'no-reply@dedicatedmaps.com',
    password: 'dmaps_email',
    authentication: 'plain',
    enable_starttls_auto: true
}