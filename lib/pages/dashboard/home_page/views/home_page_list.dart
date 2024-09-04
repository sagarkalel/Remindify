part of 'home_page_view.dart';

class HomePageList extends StatelessWidget {
  const HomePageList({super.key, required this.contactInfoList});

  final List<ContactInfoModel> contactInfoList;

  @override
  Widget build(BuildContext context) {
    if (contactInfoList.isEmpty) {
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
                "Upcoming Events (${contactInfoList.length})",
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
              itemCount: contactInfoList.length,
              itemBuilder: (_, i) => HomePageListTile(item: contactInfoList[i]),
            ),
          )
        ],
      ),
    );
  }
}
