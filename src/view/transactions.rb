#!/usr/bin/env ruby
# View::Transactions -- xmlconv2 -- 09.06.2004 -- hwyss@ywesee.com

require 'htmlgrid/list'
require 'htmlgrid/value'
require 'view/template'

module XmlConv
	module View
		class TransactionsList < HtmlGrid::List
			BACKGROUND_SUFFIX = ' bg'
			COMPONENTS = {
				[0,0]	=>	:transaction_id,
				[1,0]	=>	:origin,
				[2,0]	=>	:commit_time,
				[3,0]	=>	:uri,
				[5,0]	=>	:status_comparable,
			}
			CSS_CLASS = 'composite'
			CSS_HEAD_MAP = {
				[0,0]	=>	'right',
			}
			CSS_MAP = {
				[0,0]		=>	'list right',
				[1,0,5]	=>	'list',
			}
			DEFAULT_CLASS = HtmlGrid::Value
			LEGACY_INTERFACE = false
			SORT_DEFAULT = :commit_time
			SORT_REVERSE = true
			def commit_time(model)
				time_format(model.commit_time)
			end
			def status_comparable(model)
				model.update_status
				status = model.status
				@lookandfeel.lookup("status_#{status}") or status.to_s
			end
			def time_format(a_time)
				if(a_time.respond_to?(:strftime))
					a_time.strftime("%d.%m.%Y %H:%M:%S") 
				end
			end
			def transaction_id(model)
				link = HtmlGrid::Link.new(:transaction_id, model, @session, self)
				args = {
					'state_id'				=>	@session.state.id,
					'transaction_id'	=>	model.transaction_id,
				}
				link.href = @lookandfeel.event_url(:transaction, args)
				link.value = model.transaction_id
				link
			end
		end
		class Transactions < Template
			CONTENT = TransactionsList
		end
	end
end