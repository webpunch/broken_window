namespace :broken_window do
  desc "Take measurements for all metrics"
  task :measure => :environment do
    BrokenWindow::Measurer.call
  end
end

