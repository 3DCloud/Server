# frozen_string_literal: true

module Mutations
  class StartPrint < BaseMutation
    argument :file_id, ID, required: true
    argument :printer_id, ID, required: true

    type Types::PrintType

    def resolve(file_id:, printer_id:)
      authorize!(:create, Print)

      user_id = context[:current_user].id
      upload = UploadedFile.find_by!(id: file_id, user_id: user_id)
      printer = Printer.find_by!(id: printer_id)

      authorize!(:read, upload)
      authorize!(:read, printer)

      if printer.state != 'ready'
        raise RuntimeError.new('Printer is not ready')
      end

      print = Print.new(uploaded_file_id: upload.id, printer_id: printer.id, status: 'pending')
      print.save!

      printer.current_print = print
      printer.save!

      begin
        PrinterChannel.transmit_start_print(
          printer: printer,
          print_id: print.id,
          download_url: upload.file.url,
        )
      rescue
        print.status = 'errored'
        print.save!
        raise
      end

      print
    end
  end
end
