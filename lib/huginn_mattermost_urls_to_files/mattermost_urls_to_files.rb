module Agents
  class MattermostUrlsToFiles < Agent
    default_schedule '12h'

    description <<-MD
      Add a Agent description here
    MD

    def default_options
      {
        'mattermost_server_url' => 'https://mattermost.com/',
        'mattermost_team' => 'team_name',
        'mattermost_channel' => 'channel_name',
        'mattermost_token' => '{% credential mattermost_token %}',
        'urls' => '{{urls}}',
        'message' => '{{message}}'
      }
    end

    def validate_options
    end

    def working?
      true
    end

#    def check
#    end

    def receive(incoming_events)
      interpolate_with_each(incoming_events) do |event|
        if interpolated['urls'].is_a?(Array)
          interpolated['urls'].each do |url|
            send_message post_file(url)
          end
        else
          url = interpolated['urls']
          send_message post_file urls
        end
      end
    end

    def send_message(file_ids)
      payload = {
        channel_id: channel_id,
        message: interpolated['message'],
        file_ids: file_ids
      }
      resp = mattermost_client.post("/api/v4/posts", payload)
    end

    def post_file(url)
      file_resp = Faraday.get(url)
      return nil unless file_resp.status == 200
      
      tempfile = Tempfile.new('download')
      tempfile.write file_resp.body
      tempfile.close

      payload = {channel_id: channel_id()}
      payload[:files] = Faraday::FilePart.new(tempfile.path, file_resp.headers['Content-Type'])

      response = mattermost_client.post("/api/v4/files", payload)
      tempfile.unlink
      mm_file = JSON.parse(response.body)

      mm_file[:file_infos].each_with_object([]) do |fi, li|
        li <<= fi[:id]
      end

    end

    def mattermost_client
      @mattermost_client ||= Faraday.new(url: interpolated['mattermost_server_url']) do |builder|
        builder.request :retry
        builder.request :multipart
        builder.authorization :Bearer, interpolated['mattermost_token']
        builder.adapter :net_http
      end
    end

    def channel_id
      team_name = interpolated['mattermost_team']
      channel_name = interpolated['mattermost_channel']

      memory['channel_lookup'] ||= {}
      memory['channel_lookup'][team_name] ||= begin
        team_info = {}
        resp = mattermost_client.get("/api/v4/teams/name/#{team_name}")
        if resp.status != 200
          #Error Handling
        end
        body = JSON.parse(resp.body)
        team_info['_id'] = body['id']
        team_info
      end
      memory['channel_lookup'][team_name][channel_name] ||= begin
        team_id = memory['channel_lookup'][team_name]['_id']
        resp = mattermost_client.get("/api/v4/teams/#{team_id}/channels/name/#{channel_name}")
        unless resp.status == 200

        end
        body = JSON.parse(resp.body)
        body['id']
      end
      memory['channel_lookup'][team_name][channel_name]
    end


  end
end
