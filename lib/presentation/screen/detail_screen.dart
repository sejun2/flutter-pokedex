import 'package:auto_route/auto_route.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/domain/model/pokemon_detail_info.dart';
import 'package:pokedex/presentation/viewmodel/pokemon_detail_screen_view_model.dart';
import 'package:pokedex/presentation/viewmodel/pokemon_list_view_model.dart';

@RoutePage()
class DetailScreen extends HookConsumerWidget {
  final int pokdexId;

  const DetailScreen({
    super.key,
    required this.pokdexId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final info = ref.watch(pokemonDetailScreenViewModelProvider(pokdexId)
        .select((value) => value.pokemonDetailInfo));

    return Scaffold(
      backgroundColor: Colors.white,
      body: info == null ? _Placeholder() : _Content(info: info),
    );
  }
}

class _Placeholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PokemonTypeBackground(
          color: Colors.grey,
        ),
      ],
    );
  }
}

class PokemonTypeBackground extends StatelessWidget {
  final Color color;

  const PokemonTypeBackground({
    super.key,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(
        MediaQuery.of(context).size.width,
        400,
      ),
      painter: _PokemonTypeBackgroundPainter(color),
    );
  }
}

class _PokemonTypeBackgroundPainter extends CustomPainter {
  final Color color;

  _PokemonTypeBackgroundPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(0, 210)
      ..quadraticBezierTo(size.width / 2, 400, size.width, 210)
      ..lineTo(size.width, 0)
      ..close();

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class _Content extends StatelessWidget {
  final PokemonDetailInfo info;

  const _Content({
    required this.info,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            PokemonTypeBackground(color: info.mainType.color),
            Positioned(
              left: 0,
              right: 0,
              top: 70,
              child: SvgPicture.asset(
                info.mainType.iconGradientAssetPath,
                width: 204,
                height: 204,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
