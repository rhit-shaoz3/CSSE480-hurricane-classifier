import 'package:final_project/models/photo.dart';
import 'package:flutter/material.dart';

class PhotoBucketRow extends StatelessWidget {
  final Photo pt;
  final void Function() onClick;

  const PhotoBucketRow({super.key, required this.pt, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return 
    ListTile(
      onTap: onClick,
      leading: const Icon(Icons.tornado_rounded),
      title: Text(pt.name, overflow: TextOverflow.ellipsis,), 
      // subtitle: Text(pt.url, overflow: TextOverflow.ellipsis,),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}