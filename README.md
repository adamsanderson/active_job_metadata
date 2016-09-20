# ActiveJobMetadata

ActiveJobMetadata lets you store and retrieve metadata associated with ActiveJob jobs regardless of the queue processing library you use.

Primary use cases include:

- Providing job status clients
- Tracking job performance

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'active_job_metadata'
```

## Usage

You can use as much or as little of ActiveJobMetadata as you need.

Use **Lifecyle** to track the current status of your job:

    class MyJob < ActiveJob::Base
      include ActiveJobMetadata::Lifecycle
      
      def perform
        #...
      end
    end
    
    job = MyJob.new
    job.enque
    job.status #=> "enqueued"
    ActiveJobMetadata.find(job.job_id) #=> {status: "enqueued"}

You can use this in RESTful controllers to let clients query for a job's status:    

    class JobsController
      def create
        job = MyJob.new
        job.enque
        
        render json: {id: job.job_id}
      end
      
      def show
        metadata = ActiveJobMetadata.find(params[:id])
        
        if metadata
          render json: metadata
        else
          render json: {message: "Not Found"}, status: 404
        end
      end
    end
    
Use the **Timing** module to track and report on execution times:

    class TimedJob < ActiveJob::Base
      include ActiveJobMetadata::Timing
      after_peform :report_timing
      
      def perform
        #...
      end
      
      def report_timing
        Rails.logger.info "Queue Duration: #{queue_duration}"
        Rails.logger.info "Processing Duration: #{working_duration}"
        Rails.logger.info "Total Duration: #{total_duration}"
      end
    end

Of course you could hook this up to [statsd](https://github.com/reinh/statsd), or any other place you collect metrics.

Use the **Metadata** module to track custom information.  For instance a long running job might report the percent complete and the name of the last file it processed:

    class LongRunningJob < ActiveJob::Base
      include ActiveJobMetadata::Metadata
      metadata :percent_complete, :current_file
      
      def perform(files)
        files.each_with_index do |file, i|
          self.percent_complete = (files.length / i.to_f)
          self.current_file = file
          
          IO.open(file) do |io|
            #...
          end
        end
      end
      
    end

Use this approach to enrich metadata you send back to your client.

## Configuration

Although ActiveJobMetadata should mostly work out of the box in a development environment, you will probably want to customize the backing store.  ActiveJobMetadata reads and writes to an [ActiveSupport::Cache::Store](http://api.rubyonrails.org/classes/ActiveSupport/Cache/Store.html).  If you use more than one web server, which is likely, you will probably want to use something like [Readthis](https://github.com/sorentwo/readthis) which provides a shared interface via Redis.  If you want to use a different backend for ActiveJobMetadata than Rails, create an initializer with your custom store:

    # initializers/active_job_metadata.rb
    
    # Configure ActiveJobMetadata to use Readthis:
    ActiveJobMetadata.store = Readthis::Cache.new(
      expires_in: 2.days.to_i
    )

Currently ActiveJobMetadata only uses the `read` and `write` methods, so you can easily store your metadata wherever all your servers can easily access it if you don't mind implementing something that quacks like a [ActiveSupport::Cache::Store](http://api.rubyonrails.org/classes/ActiveSupport/Cache/Store.html).

## Alternatives

It is always wise to consider your alternatives:

* [active_job_status](https://github.com/cdale77/active_job_status)
* [resque-status](https://github.com/quirkey/resque-status) for Resque
* [sidekiq-status](https://github.com/utgarda/sidekiq-status) for Sidekiq

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/adamsanderson/active_job_metadata.

