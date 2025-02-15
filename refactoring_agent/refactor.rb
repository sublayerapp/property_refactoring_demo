require "octokit"
require "pry"
require "yaml"
require "sublayer"
require "asana"

# Load any Actions, Generators, and Agents
Dir[File.join(__dir__, "actions", "*.rb")].each { |file| require file }
Dir[File.join(__dir__, "generators", "*.rb")].each { |file| require file }
Dir[File.join(__dir__, "triggers", "*.rb")].each { |file| require file }
Dir[File.join(__dir__, "agents", "*.rb")].each { |file| require file }
Sublayer.configuration.ai_provider = Sublayer::Providers::Gemini
Sublayer.configuration.ai_model = "gemini-2.0-flash"

f = File.read(File.join(__dir__, "../app/models/property.rb"))

analysis = RefactoringAnalysisGenerator.new(code: f).generate
puts "Analyzed app/models/property.rb"
refactoring_plan = RefactoringPlanGenerator.new(code: f, code_analysis: analysis).generate
puts "Generated refactoring plan"

refactoring_plan.each do |refactoring_step|
  puts "Creating refactoring task in asana for #{refactoring_step.title}"
  CreateAsanaTaskAction.new(
    project_id: ENV["REFACTORING_ASANA_PROJECT_ID"],
    name: "#{refactoring_step.title} || Priority: #{refactoring_step.priority}, Complexity: #{refactoring_step.complexity}",
    description: refactoring_step.description
  ).call
end

refactoring_agent = RefactoringAgent.new(code: f, refactoring_steps: refactoring_plan).run
