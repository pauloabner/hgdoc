module Hgdoc
  class GoogleConnector
    require 'google/apis/drive_v3'
    require 'googleauth'
    require 'googleauth/stores/file_token_store'

    require 'fileutils'

    OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'.freeze
    APPLICATION_NAME = 'HGDoc'
    SCOPE = 'https://www.googleapis.com/auth/drive.file'.freeze

    def initialize(client_secrets_path, credentials_path)
        @client_secrets_path = client_secrets_path
        @credentials_path = credentials_path
        @service = Google::Apis::DriveV3::DriveService.new
        @service.client_options.application_name = APPLICATION_NAME
        @service.authorization = authorize
    end

    def upload(file)
        metadata = {
        name: 'HedraConvertFile-' << Time.now.strftime('%Y%m%d%H%M%S'),
        mime_type: 'application/vnd.google-apps.document'
        }
        result = @service.create_file(metadata, upload_source: file)
        result.id
    end

    def download_as_html(google_filedocument_id, output_file: nil)
        dest = output_file || StringIO.new
        @service.export_file(google_filedocument_id,
                            'text/html',
                            download_dest: dest)
        return unless dest.is_a?(StringIO)
        dest.rewind
        dest.read
    end

    private

    def authorize
        authorizer = Google::Auth::UserAuthorizer.new(
        client_id, SCOPE, token_store)
        user_id = 'default'
        credentials = authorizer.get_credentials(user_id)
        if credentials.nil?
        code = authorization_code(authorizer)
        credentials = authorizer.get_and_store_credentials_from_code(
            user_id: user_id, code: code, base_url: OOB_URI)
        end
        credentials
    end

    def authorization_code(authorizer)
        url = authorizer.get_authorization_url(
        base_url: OOB_URI)
        puts 'Open the following URL in the browser and enter the ' \
            'resulting code after authorization'
        puts url
        gets
    end

    def client_id
        Google::Auth::ClientId.from_file(@client_secrets_path)
    end

    def token_store
        FileUtils.mkdir_p(File.dirname(@credentials_path))
        Google::Auth::Stores::FileTokenStore.new(file: @credentials_path)
    end
  end
end