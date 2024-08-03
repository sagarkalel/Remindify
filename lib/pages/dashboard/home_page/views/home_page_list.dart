part of 'home_page_view.dart';

class HomePageList extends StatelessWidget {
  const HomePageList({super.key, required this.myContacts});

  final List<MyContactModel> myContacts;

  @override
  Widget build(BuildContext context) {
    if (myContacts.isEmpty) {
      return const Center(child: Text("No contacts found!"));
    }
    return ExtendedNestedScrollView(
      floatHeaderSlivers: true,
      physics: const BouncingScrollPhysics(),
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const YGap(16),
              Text(
                "Upcoming Events (${myContacts.length})",
                style: Theme.of(context).textTheme.titleLarge,
              ).padXXDefault
            ],
          ),
        )
      ],
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 4,
                bottom: getScreenY(context) * 0.15),
            sliver: SliverList.builder(
              itemCount: myContacts.length + 1,
              itemBuilder: (_, i) => HomePageListTile(item: myContacts[i]),
            ),
          )
        ],
      ),
    );
  }
}
