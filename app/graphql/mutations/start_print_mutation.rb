# frozen_string_literal: true

module Mutations
  class StartPrintMutation < BaseMutation
    argument :file_id, ID, required: true
    argument :printer_id, ID, required: true

    type Types::PrintType

    def resolve(file_id:, printer_id:)
      user_id = context[:current_user].id
      upload = UploadedFile.find_by!(id: file_id, user_id: user_id)
      printer = Printer.find_by!(id: printer_id)

      if printer.state != 'ready'
        raise RuntimeError.new('Printer is not ready')
      end

      print = Print.new(uploaded_file_id: upload.id, printer_id: printer.id, status: 'pending')

      print.save!

      PrinterChannel.transmit_start_print(
        printer: printer,
        print_id: print.id,
        download_url: upload.file.url,
      )

      print
    end
  end
end
