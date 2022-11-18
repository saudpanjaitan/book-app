import 'package:book_app/controllers/book_controllers.dart';
import 'package:book_app/views/image_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailBookPage extends StatefulWidget {
  const DetailBookPage({
    super.key,
    required this.isbn,
  });
  final String isbn;

  @override
  State<DetailBookPage> createState() => _DetailBookPageState();
}

class _DetailBookPageState extends State<DetailBookPage> {
  BookControllers? controllers;

  @override
  void initState() {
    super.initState();
    controllers = Provider.of<BookControllers>(context, listen: false);
    controllers!.fetchDetailBookApi(widget.isbn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail"),
      ),
      body: Consumer<BookControllers>(builder: (context, controllers, child) {
        return controllers.detailBook == null
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ImageViewScreen(
                                    imageUrl: controllers.detailBook!.image!),
                              ),
                            );
                          },
                          child: Image.network(
                            controllers.detailBook!.image!,
                            height: 150,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controllers.detailBook!.title!,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  controllers.detailBook!.authors!,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: List.generate(
                                    5,
                                    (index) => Icon(
                                      Icons.star,
                                      color: index <
                                              int.parse(controllers
                                                  .detailBook!.rating!)
                                          ? Colors.yellow
                                          : Colors.grey,
                                    ),
                                  ),
                                ),
                                Text(
                                  controllers.detailBook!.subtitle!,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  controllers.detailBook!.price!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(),
                        onPressed: () async {
                          Uri uri = Uri.parse(controllers.detailBook!.url!);
                          try {
                            (await canLaunchUrl(uri))
                                ? launchUrl(uri)
                                : debugPrint("Tidak berhasil navigasi");
                          } catch (e) {
                            debugPrint("error");
                          }
                        },
                        child: const Text("BUY"),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(controllers.detailBook!.desc!),
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text("Year : ${controllers.detailBook!.year!}"),
                        Text("ISBN ${controllers.detailBook!.isbn13!}"),
                        Text("${controllers.detailBook!.pages!} Page"),
                        Text(
                            "Publisher : ${controllers.detailBook!.publisher!}"),
                        Text("Language : ${controllers.detailBook!.language!}"),
                      ],
                    ),
                    const Divider(),
                    controllers.similiarBooks == null
                        ? const CircularProgressIndicator()
                        : SizedBox(
                            height: 180,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  controllers.similiarBooks!.books!.length,
                              itemBuilder: (context, index) {
                                final current =
                                    controllers.similiarBooks!.books![index];
                                return SizedBox(
                                  width: 100,
                                  child: Column(
                                    children: [
                                      Image.network(
                                        current.image!,
                                        height: 100,
                                      ),
                                      Text(
                                        current.title!,
                                        maxLines: 3,
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          )
                  ],
                ),
              );
      }),
    );
  }
}
