/// Filter options for the Enrolled Clients list.
enum ClientFilter { all, active, pending }

extension ClientFilterLabel on ClientFilter {
  String get label {
    switch (this) {
      case ClientFilter.all:
        return 'All';
      case ClientFilter.active:
        return 'Active';
      case ClientFilter.pending:
        return 'Pending';
    }
  }
}
