class FilterListModel {
  final String title, value;

  const FilterListModel({required this.title, required this.value});
}

List<FilterListModel> filterList = const [
  FilterListModel(value: 'default', title: 'Default (Default)'),
  FilterListModel(value: 'most_recent', title: 'Most Recent'),
  FilterListModel(value: 'oldest_first', title: 'Oldest First'),
  FilterListModel(value: 'alphabetical_order', title: 'Alphabetical Order'),
  FilterListModel(value: 'with_event', title: 'With Event'),
  FilterListModel(value: 'without_event', title: 'Without Event'),
  FilterListModel(value: 'birthday_events', title: 'Birthday Events'),
  FilterListModel(value: 'anniversary_events', title: 'Anniversary Events'),
  FilterListModel(value: 'other_events', title: 'Other Events'),
];
