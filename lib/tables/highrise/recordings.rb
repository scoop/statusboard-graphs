module Tables
  module Highrise
    class Recordings < Base
      filename 'recordings.html'

      def fetch
        @recordings = {}.tap do |recordings|
          ::Highrise::Recording.find_all_across_pages_since(Time.now.midnight).group_by(&:author_id).each do |user_id, user_recordings|
            user_recordings.reject! { |ur| !%w( Note Email Comment ).include? ur.type.to_s }
            user = ::Highrise::User.find user_id
            recordings.update user.name.split.first => {
              size: user_recordings.size,
              bar: size_bar(user_recordings.size)
            }
          end
        end.sort_by { |name, values| values[:size] }.reverse
      end

      def size_bar(size)
        (size / 5).to_i
      end

    end
  end
end
