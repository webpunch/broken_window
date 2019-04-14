namespace :broken_window do
  desc "Take measurements for all metrics"
  task measure: :environment do
    BrokenWindow::Measurer.call
  end

  desc "Reports broken_window incorrect metrics to slack webhook urls"
  task notify_slack: :environment do
    BrokenWindow::SlackNotifier.call
  end
end

