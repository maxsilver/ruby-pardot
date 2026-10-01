module Pardot
  module Objects
    # Canonical visitor activity types, per the Account Engagement (Pardot)
    # object field reference:
    # https://developer.salesforce.com/docs/marketing/pardot/guide/object-field-reference.html#visitor-activity-types
    #
    # The API's own `type_name` values are unreliable: several distinct codes
    # (e.g. 6 "Sent", 11 "Open", 13 "Bounced") are all returned with the
    # generic type_name "Email", and the same code can be labeled differently
    # on different records. Use `VisitorActivityTypes.name_for(type)` instead,
    # which maps the numeric `type` to its documented name.
    module VisitorActivityTypes
      NAMES = {
        1 => 'Click',
        2 => 'View',
        3 => 'Error',
        4 => 'Success',
        5 => 'Session',
        6 => 'Sent',
        7 => 'Search',
        8 => 'New Opportunity',
        9 => 'Opportunity Won',
        10 => 'Opportunity Lost',
        11 => 'Open',
        12 => 'Unsubscribe Page',
        13 => 'Bounced',
        14 => 'Spam Complaint',
        15 => 'Email Preference Page',
        16 => 'Resubscribed',
        17 => 'Click (Third Party)',
        18 => 'Opportunity Reopened',
        19 => 'Opportunity Linked',
        20 => 'Visit',
        21 => 'Custom URL click',
        22 => 'Olark Chat',
        23 => 'Invited to Webinar',
        24 => 'Attended Webinar',
        25 => 'Registered for Webinar',
        26 => 'Social Post Click',
        27 => 'Video View',
        28 => 'Event Registered',
        29 => 'Event Checked In',
        30 => 'Video Conversion',
        31 => 'UserVoice Suggestion',
        32 => 'UserVoice Comment',
        33 => 'UserVoice Ticket',
        34 => 'Video Watched (>= 75% watched)',
        35 => 'Indirect Unsubscribe Open',
        36 => 'Indirect Bounce',
        37 => 'Indirect Resubscribed',
        38 => 'Opportunity Unlinked'
      }.freeze

      UNKNOWN = 'Unknown'

      def self.name_for(type)
        NAMES[type.to_i] || UNKNOWN
      end
    end
  end
end
