import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ipfoam_client/main.dart';
import 'package:ipfoam_client/repo.dart';
import 'package:ipfoam_client/note.dart';
import 'package:ipfoam_client/transforms/abstraction_reference_link.dart';
import 'package:ipfoam_client/utils.dart';
import 'package:provider/provider.dart';

class NoteViewer extends StatelessWidget {
  final String iid;

  NoteViewer({required this.iid});

  String getStatusText(String? iid, String? cid, Note? note) {
    return "IID: " +
        iid.toString() +
        "\nCID: " +
        cid.toString() +
        "\nNOTE: " +
        note.toString();
  }

  Widget buildPropertyRow(String typeIid, dynamic content, Repo repo) {
    Note? typeNote;
    String propertyName = typeIid;
    String? cid = repo.getCidWrapByIid(typeIid).cid;
    if (cid != null) {
      typeNote = repo.getNoteWrapByCid(cid).note;
      if (typeNote != null) {
        propertyName = typeNote.block![Note.primitiveDefaultName];
      }
    } else {}

    return Container(
        child: Column(
      children: [
        buildPropertyText(propertyName),
        buildContentByType(typeNote, content, repo)
      ],
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
    ));
  }

  Widget buildPropertyText(String typeIid) {
    String str = typeIid;

    return Text(str,
        textAlign: TextAlign.left,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
            fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 20));
  }

  Widget buildContentByType(Note? typeNote, dynamic content, Repo repo) {
    if (typeNote != null && typeNote.block != null) {
      if (Utils.typeIsStruct(typeNote)) {
        log(typeNote.block![Note.primitiveDefaultName] + " IN");

        return buildStruct(typeNote, content, repo);
      } else if (typeNote.block![Note.primitiveConstrains] != null) {
        //STRING
        if (Utils.getBasicType(typeNote) == Note.basicTypeString) {
        }
        //Abstraction reference link
        else if (Utils.getBasicType(typeNote) ==
            Note.basicTypeAbstractionReference) {
          return AbstractionReferenceLink(
              aref: AbstractionReference.fromText(content.toString()));
        }
        //

        // List of Abstraction reference links
        else if (Utils.getBasicType(typeNote) ==
            Note.basicTypeAbstractionReferenceList) {
          List<AbstractionReferenceLink> items = [];
          content.forEach((element) {
            items.add(AbstractionReferenceLink(
                aref: AbstractionReference.fromText(element.toString())));
          });

          return ListView(
            // padding: const EdgeInsets.all(8),
            children: items,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
          );
        } else if (Utils.getBasicType(typeNote) == Note.basicTypeBoolean) {
          return buildContentRaw(typeNote, "BOolean");
        } else if (Utils.getBasicType(typeNote) == Note.basicTypeDate) {
          return buildContentRaw(typeNote, "Date");
        } else if (Utils.getBasicType(typeNote) == Note.basicTypeUrl) {
          return buildContentRaw(typeNote, "Url");
        }
      } else {
        log(typeNote.block![Note.primitiveDefaultName] + " OUT");
        return buildContentRaw(typeNote, content);
      }
    }
    return Text(content.toString(),
        textAlign: TextAlign.left,
        overflow: TextOverflow.visible,
        style: const TextStyle(
            fontWeight: FontWeight.normal, color: Colors.black, fontSize: 20));
  }

  Widget buildContentRaw(Note? typeNote, dynamic content) {
    return Text(content.toString(),
        textAlign: TextAlign.left,
        overflow: TextOverflow.visible,
        style: const TextStyle(
            fontWeight: FontWeight.normal, color: Colors.black, fontSize: 20));
  }

  @override
  Widget build(BuildContext context) {
    final repo = Provider.of<Repo>(context);

    IidWrap iidWrap = repo.getCidWrapByIid(iid);

    if (iidWrap.cid == null) {
      return Text(getStatusText(iid, iidWrap.cid, null));
    }
    CidWrap cidWrap = repo.getNoteWrapByCid(iidWrap.cid!);

    if (cidWrap.note == null) {
      return Text(getStatusText(iid, iidWrap.cid, cidWrap.note));
    }

    List<Widget> items = [];

    cidWrap.note!.block!.forEach((key, value) {
      items.add(buildPropertyRow(key, value, repo));
    });

    return SizedBox(
      width: 600,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          // padding: const EdgeInsets.all(8),
          children: items,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
        ),
      ),
    );
  }

  buildStruct(Note? typeNote, dynamic content, Repo repo) {
    List<Widget> items = [];

    content!.forEach((key, value) {
      items.add(buildPropertyRow(key, value, repo));
      log(key + " - " + value.toString());
    });
    //return Text("Struct");
    return ListView(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
      children: items,
    );
  }
}
