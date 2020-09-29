<?php

namespace App\DataFixtures;

use Doctrine\Bundle\FixturesBundle\Fixture;
use Doctrine\Persistence\ObjectManager;
use App\Entity\Utilisateur;
use App\Entity\CompteBancaire;
use App\Entity\CarteBancaire;

class AppFixtures extends Fixture
{
    public function load(ObjectManager $manager)
    {
        $firstCarteBancaire = new CarteBancaire();
        $firstCarteBancaire
            ->setNumero('1111222233334444')
            ->setIdReferencePartenaire(0)
            ->setStatus(1)
            ->setDateExpiration(new \DateTime('01/12/2023'))
        ;
        $secondCarteBancaire = new CarteBancaire();
        $secondCarteBancaire
            ->setNumero('1111222233334444')
            ->setIdReferencePartenaire(1)
            ->setStatus(1)
            ->setDateExpiration(new \DateTime('01/12/2023'))
        ;
        $thirdCarteBancaire = new CarteBancaire();
        $thirdCarteBancaire
            ->setNumero('1111222233334444')
            ->setIdReferencePartenaire(2)
            ->setStatus(1)
            ->setDateExpiration(new \DateTime('01/12/2023'))
        ;
        $fourthCarteBancaire = new CarteBancaire();
        $fourthCarteBancaire
            ->setNumero('1111222233334444')
            ->setIdReferencePartenaire(3)
            ->setStatus(1)
            ->setDateExpiration(new \DateTime('01/12/2023'))
        ;
        $fithCarteBancaire = new CarteBancaire();
        $fithCarteBancaire
            ->setNumero('1111222233334444')
            ->setIdReferencePartenaire(4)
            ->setStatus(1)
            ->setDateExpiration(new \DateTime('01/12/2023'))
        ;

        $firstUtilisateur = new Utilisateur();
        $firstUtilisateur
            ->setNom('Ricciardo')
            ->setPrenom('Daniel')
            ->setDateNaissance(new \DateTime('01/07/1989'))
            ->setEmail('honey.badger@fia.com')
        ;
        $secondUtilisateur = new Utilisateur();
        $secondUtilisateur
            ->setNom('Gasly')
            ->setPrenom('Pierre')
            ->setDateNaissance(new \DateTime('07/02/1996'))
            ->setEmail('pierrot-monza2020@fia.com')
        ;
        $thirdUtilisateur = new Utilisateur();
        $thirdUtilisateur
            ->setNom('Vettel')
            ->setPrenom('Sebastian')
            ->setDateNaissance(new \DateTime('03/07/1987'))
            ->setEmail('babyschumy@fia.com')
        ;

        $firstCompteBancaire = new CompteBancaire();
        $firstCompteBancaire
            ->setIban('NL21ABNA3665292913')
            ->setBic('BBPIFRPP')
            ->setIdReferencePartenaire(0)
            ->setBalance(12000)
            ->setUtilisateur($firstUtilisateur)
            ->setCarteBancaire($firstCarteBancaire)
        ;
        $secondCompteBancaire = new CompteBancaire();
            $secondCompteBancaire
            ->setIban('NL37ABNA9788055427')
            ->setBic('BBPIFRPP')
            ->setIdReferencePartenaire(1)
            ->setBalance(120000)
            ->setUtilisateur($firstUtilisateur)
            ->setCarteBancaire($secondCarteBancaire)
        ;
        $thirdCompteBancaire = new CompteBancaire();
            $thirdCompteBancaire
            ->setIban('NL86RABO2293362523')
            ->setBic('BBPIFRPP')
            ->setIdReferencePartenaire(2)
            ->setBalance(120)
            ->setUtilisateur($secondUtilisateur)
            ->setCarteBancaire($thirdCarteBancaire)
        ;
        $fourthCompteBancaire = new CompteBancaire();
        $fourthCompteBancaire
            ->setIban('NL15ABNA9712139840')
            ->setBic('BBPIFRPP')
            ->setIdReferencePartenaire(3)
            ->setBalance(4500)
            ->setUtilisateur($thirdUtilisateur)
            ->setCarteBancaire($fourthCarteBancaire)
        ;
        $fithCompteBancaire = new CompteBancaire();
        $fithCompteBancaire
            ->setIban('NL89RABO1383283540')
            ->setBic('BBPIFRPP')
            ->setIdReferencePartenaire(4)
            ->setBalance(30000)
            ->setUtilisateur($thirdUtilisateur)
            ->setCarteBancaire($fithCarteBancaire)
        ;
        
        $manager->persist($firstCarteBancaire);
        $manager->persist($secondCarteBancaire);
        $manager->persist($thirdCarteBancaire);
        $manager->persist($fourthCarteBancaire);
        $manager->persist($fithCarteBancaire);
        $manager->persist($firstCompteBancaire);
        $manager->persist($secondCompteBancaire);
        $manager->persist($thirdCompteBancaire);
        $manager->persist($fourthCompteBancaire);
        $manager->persist($fithCompteBancaire);
        $manager->persist($firstUtilisateur);
        $manager->persist($secondUtilisateur);
        $manager->persist($thirdUtilisateur);

        $manager->flush();
    }
}
