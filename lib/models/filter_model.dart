class FilterModel {
  final String title, value;

  const FilterModel({required this.title, required this.value});
}

List<FilterModel> filterList = const [
  FilterModel(value: 'default', title: 'Default (Default)'),
  FilterModel(value: 'most_recent', title: 'Most Recent'),
  FilterModel(value: 'oldest_first', title: 'Oldest First'),
  FilterModel(value: 'alphabetical_order', title: 'Alphabetical Order'),
  FilterModel(value: 'with_event', title: 'With Event'),
  FilterModel(value: 'without_event', title: 'Without Event'),
  FilterModel(value: 'birthday_events', title: 'Birthday Events'),
  FilterModel(value: 'anniversary_events', title: 'Anniversary Events'),
  FilterModel(value: 'other_events', title: 'Other Events'),
];
