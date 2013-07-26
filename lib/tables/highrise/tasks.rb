module Tables
  module Highrise
    class Tasks < Base
      filename 'tasks.html'

      def fetch
        @tasks = {}.tap do |tasks|
          ::Highrise::Task.find(:all, from: :all).group_by(&:author_id).each do |user_id, user_tasks|
            user_tasks.reject! { |ut| ut.due_at && ut.due_at > Time.now.end_of_week }
            next if user_tasks.size.zero?
            user = ::Highrise::User.find user_id
            tasks.update user.name => {
              size: user_tasks.size,
              bar: size_bar(user_tasks.size)
            }
          end
        end.sort_by { |name, values| values[:size] }.reverse
      end

      def size_bar(size)
        (size / 10).to_i
      end

    end
  end
end
