# frozen_string_literal: true

class LashaMailer < LashaApplicationMailer
  def notify(destination_email, subject, body)
    @data = { subject: subject, body: body }
    mail(
      to: destination_email,
      subject: subject,
      template_path: "mailers/lasha"
      # template_name: "notify"
    )
  end

  def self.admin_periodic_notifier(key, message, timeout)
    if Rails.cache.read(key).blank?

      LashaMailer.notify(Rails.application.credentials[:admin_mail], "admin_periodic_notifier", message).deliver_later

      Rails.cache.write(key, true, expires_in: timeout)
    else
      Rails.logger.info("***** Admin periodic notifier on cooldown")
    end
  end
end
