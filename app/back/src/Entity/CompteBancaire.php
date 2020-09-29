<?php

namespace App\Entity;

use App\Repository\CompteBancaireRepository;
use Doctrine\ORM\Mapping as ORM;
use ApiPlatform\Core\Annotation\ApiResource;

/**
 * @ORM\Entity(repositoryClass=CompteBancaireRepository::class)
 * @ApiResource
 */
class CompteBancaire
{
    /**
     * @ORM\Id
     * @ORM\GeneratedValue
     * @ORM\Column(type="integer")
     */
    private $id;

    /**
     * @ORM\Column(type="string", length=30)
     */
    private $iban;

    /**
     * @ORM\Column(type="string", length=11)
     */
    private $bic;

    /**
     * @ORM\Column(type="integer")
     */
    private $idReferencePartenaire;

    /**
     * @ORM\Column(type="bigint")
     */
    private $balance;

    /**
     * @ORM\OneToOne(targetEntity=CarteBancaire::class, mappedBy="compteBancaire", cascade={"persist", "remove"})
     */
    private $carteBancaire;

    /**
     * @ORM\ManyToOne(targetEntity=Utilisateur::class, inversedBy="compteBancaires")
     * @ORM\JoinColumn(nullable=false)
     */
    private $utilisateur;

    public function getId(): ?int
    {
        return $this->id;
    }

    public function getIban(): ?string
    {
        return $this->iban;
    }

    public function setIban(string $iban): self
    {
        $this->iban = $iban;

        return $this;
    }

    public function getBic(): ?string
    {
        return $this->bic;
    }

    public function setBic(string $bic): self
    {
        $this->bic = $bic;

        return $this;
    }

    public function getIdReferencePartenaire(): ?int
    {
        return $this->idReferencePartenaire;
    }

    public function setIdReferencePartenaire(int $idReferencePartenaire): self
    {
        $this->idReferencePartenaire = $idReferencePartenaire;

        return $this;
    }

    public function getBalance(): ?string
    {
        return $this->balance;
    }

    public function setBalance(string $balance): self
    {
        $this->balance = $balance;

        return $this;
    }

    public function getCarteBancaire(): ?CarteBancaire
    {
        return $this->carteBancaire;
    }

    public function setCarteBancaire(CarteBancaire $carteBancaire): self
    {
        $this->carteBancaire = $carteBancaire;

        // set the owning side of the relation if necessary
        if ($carteBancaire->getCompteBancaire() !== $this) {
            $carteBancaire->setCompteBancaire($this);
        }

        return $this;
    }

    public function getUtilisateur(): ?Utilisateur
    {
        return $this->utilisateur;
    }

    public function setUtilisateur(?Utilisateur $utilisateur): self
    {
        $this->utilisateur = $utilisateur;

        return $this;
    }
}
