// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/domain/model/pokemon_detail_info.dart';
import 'package:pokedex/gen/assets.gen.dart';
import 'package:pokedex/presentation/components/pokemon_gender_ratio_view.dart';
import 'package:pokedex/presentation/components/pokemon_status_group_view.dart';
import 'package:pokedex/presentation/components/pokemon_type_chip.dart';
import 'package:pokedex/presentation/viewmodel/pokemon_detail_screen_view_model.dart';
import 'package:pokedex/util/extentions.dart';

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
      body: AnimatedCrossFade(
        firstCurve: Curves.easeIn,
        secondCurve: Curves.easeOut,
        alignment: Alignment.topCenter,
        duration: const Duration(milliseconds: 300),
        firstChild: _Placeholder(),
        secondChild: info != null ? _Content(info: info) : const SizedBox(),
        crossFadeState:
            info == null ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: const [
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
        330,
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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
              Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: _PokemonImage(info: info)),
              Positioned(
                left: 16,
                top: 16 + MediaQuery.of(context).padding.top,
                child: GestureDetector(
                  onTap: () => context.router.back(),
                  child: SvgPicture.asset(
                    Assets.icons.iconArrowLeft,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                right: 20,
                top: 16 + MediaQuery.of(context).padding.top,
                child: SvgPicture.asset(
                  Assets.icons.iconFavOff2,
                  width: 28,
                  height: 28,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 18,
                bottom: 26 + MediaQuery.of(context).padding.bottom),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  info.name.capitalizeFirst(),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  info.pokedexId.pokedexIdFormat(),
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(color: Colors.black.withOpacity(0.7)),
                ),
                const Gap(24),
                Row(
                    children: info.types
                        .mapIndexed((i, type) => Padding(
                            padding: EdgeInsets.only(left: i == 0 ? 0 : 7),
                            child: PokemonTypeChip.large(type)))
                        .toList()),
                const Gap(24),
                Text(
                  info.desc,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.black.withOpacity(0.7),
                      ),
                ),
                const Gap(24),
                Divider(
                  color: Colors.black.withOpacity(0.05),
                  height: 1,
                ),
                const Gap(24),
                PokemonStatusGroupView(info: info),
                const Gap(28),
                PokemonGenderRatioView(
                  genderRate: info.genderRate,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PokemonImage extends HookConsumerWidget {
  const _PokemonImage({
    required this.info,
  });

  final PokemonDetailInfo info;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageSize = useState(Size.zero);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        imageSize.value = await _calculateImageDimension();
      });
      return null;
    }, []);

    return Image.network(
      info.imageUrl,
      width: imageSize.value.width,
      height: imageSize.value.height,
      fit: BoxFit.contain,
    );
  }

  Future<Size> _calculateImageDimension() {
    final Completer<Size> completer = Completer();
    final image = Image.network(
      info.imageUrl,
    );
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener(
        (image, _) {
          final myImage = image.image;
          final targetWidth = min(300.0, myImage.width.toDouble() * 2.5);
          final targetHeight = min(300.0, myImage.height.toDouble() * 2.5);

          if (!completer.isCompleted) {
            completer.complete(Size(targetWidth, targetHeight));
          }
        },
      ),
    );
    return completer.future;
  }
}
